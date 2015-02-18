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
  validate :term_cannot_be_in_past

  def close_time_cannot_be_in_past_of_open_time
    unless close_at.blank? || open_at.blank?
      if open_at >= close_at
        errors.add(:close_at, 'invalid close time')
      end
    end
  end

  def term_cannot_be_in_past
    unless close_at.blank? || open_at.blank?
      errors.add(:open_at, "open time can't be in the past") if Time.now >= open_at
      errors.add(:close_at, "close time can't be in the past") if Time.now >= close_at
    end
  end

  def ready?
    open_at >= Time.now
  end

  scope :unopened, -> {
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
