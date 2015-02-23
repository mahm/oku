class Auction < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  has_many :bids

  validates :user_id, presence: true
  validates :open_at, presence: true
  validates :close_at, presence: true
  validates :title, presence: true
  validates :amount, presence: true, numericality: {only_integer: true, greater_than: 0}
  validates :category_id, presence: true
  validates :first_price, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :highest_price, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}

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

  def biddable?(bidder_id)
    open? && user_id != bidder_id
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
end
