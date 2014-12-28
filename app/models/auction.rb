class Auction < ActiveRecord::Base
  belongs_to :item
  belongs_to :user
  has_many :bids

  validates :item_id, presence: true
  validates :user_id, presence: true
  validates :open_at, presence: true
  validates :close_at, presence: true
  validates :first_price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :highest_price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

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
end
