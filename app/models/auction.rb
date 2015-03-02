class Auction < ActiveRecord::Base
  belongs_to :user # auctioneer
  belongs_to :category
  has_many :bids
  has_many :users, through: :bids # 入札者
  has_many :evaluations

  validates :user_id, presence: true
  validates :open_at, presence: true
  validates :close_at, presence: true
  validates :title, presence: true
  validates :amount, presence: true, numericality: {only_integer: true, greater_than: 0}
  validates :category_id, presence: true
  validates :first_price, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}

  validate :close_time_cannot_be_in_past_of_open_time

  def close_time_cannot_be_in_past_of_open_time
    unless close_at.blank? || open_at.blank?
      if open_at >= close_at
        errors.add(:close_at, 'invalid close time')
      end
    end
  end

  def in_ready?
    open_at >= Time.now
  end

  def open?
    Time.now >= open_at && !closed
  end

  def close?
    self.closed
  end

  def biddable?(bidder_id)
    open? && user_id != bidder_id
  end

  def highest_price
    bids.maximum(:price) || 0
  end

  def accept_and_close
    if highest_bid = bids.order(price: :desc).first
      highest_bid.accepted = true
      highest_bid.save!
    end
    self.closed = true
    save!
  end

  def already_evaluated_by?(evaluater_id)
    Evaluation.where(auction_id: self.id, evaluater_id: evaluater_id).exists?
  end

  def accepted_price
    bids.where(accepted: true).first.price if bids.present?
  end

  def successful_bidder
    bids.where(accepted: true).first.user.email if bids.present?
  end

  def accepted_by?(user_id)
    bids.where(accepted: true).first.user.id == user_id if bids.present?
  end

  scope :in_ready, -> {
    order(:open_at)
    where { (open_at.gt Time.now) }
  }
  scope :opened, -> {
    order(:close_at)
    where { (closed.eq false) & (open_at.lteq Time.now) }
  }
  scope :closed, -> {
    order('close_at DESC')
    where { (closed.eq true) }
  }
  scope :must_be_close, -> {
    where { (close_at.lteq Time.now) & (closed.eq false) }
  }

  before_destroy do
    in_ready?
  end
end
