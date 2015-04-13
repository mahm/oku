class Auction < ActiveRecord::Base
  mount_uploader :picture, ItemPictureUploader

  belongs_to :user # 出品者
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

  validate :open_time_cannot_be_in_past, unless: :close?
  validate :close_time_cannot_be_in_past_of_open_time

  # できるだけ名前付きにした方が良い
  before_destroy :only_in_ready_auction

  # scopeは通常モデルの上部に書くかなーと思います
  # こちら参考になります → https://github.com/bbatsov/rails-style-guide#activerecord

  scope :in_ready, -> {
    # .で繋がないとORDER BYが効かない
    where { (open_at.gt Time.now) }
    .order(:open_at)
  }
  scope :opened, -> {
    # .で繋がないとORDER BYが効かない
    where { (closed.eq false) & (open_at.lteq Time.now) }
    .order(:close_at)
  }
  scope :closed, -> {
    # .で繋がないとORDER BYが効かない
    where { (closed.eq true) }
    .order(close_at: :desc)
  }
  scope :must_be_close, -> {
    where { (close_at.lteq Time.now) & (closed.eq false) }
  }

  def only_in_ready_auction
    in_ready?
  end

  def in_ready?
    open_at > Time.now
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

  def biddable_price?(price)
    first_price < price && bids.maximum(:price).to_i < price
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
    # Evaluation.where(auction_id: self.id, evaluater_id: evaluater_id).exists?
    evaluations.where(evaluater_id: evaluater_id).exists?
  end

  def accepted_price
    return nil if bids.blank?
    # scope化
    bids.only_accepted.first.price
  end

  def successful_bidder
    return nil if bids.blank?
    # scope化
    bids.only_accepted.first.user
  end

  def accepted_by?(user_id)
    return false if bids.blank?
    # scope化
    bids.only_accepted.first.user.id == user_id
  end

  private

  def open_time_cannot_be_in_past
    # unlessで書かなくても良い場合はunlessを使わないほうがリーダブル
    if open_at.present?
      errors.add(:open_at, '開始時間が過去になっています') if Time.now >= open_at && !self.closed
    end
  end

  def close_time_cannot_be_in_past_of_open_time
    # unlessで書かなくても良い場合はunlessを使わないほうがリーダブル
    if open_at.present? && close_at.present?
      errors.add(:close_at, '終了時間以降に開始時間を設定できません') if open_at >= close_at
    end
  end
end
