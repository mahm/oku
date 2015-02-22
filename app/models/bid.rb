class Bid < ActiveRecord::Base
  belongs_to :auction
  belongs_to :user

  validates :auction_id, presence: true
  validates :user_id, presence: true
  validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  validate :auction_is_in_time

  def auction_is_in_time
    unless auction_id.blank?
      errors.add(:auction_id, 'auction is over') if Time.now >= auction.close_at
      errors.add(:auction_id, 'auction is not open') if auction.open_at > Time.now
    end
  end

  after_save do
    auction.highest_price = price
    auction.save
  end
end
