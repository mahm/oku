class Bid < ActiveRecord::Base
  belongs_to :auction
  belongs_to :user

  validates :auction_id, presence: true
  validates :user_id, presence: true
  validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  validate :auction_is_in_time
  validate :price_is_highest

  private

  def auction_is_in_time
    unless auction_id.blank?
      errors.add(:auction_id, 'オークションは終了しています') if Time.now >= auction.close_at && !accepted
      errors.add(:auction_id, 'オークションは準備中です') if auction.open_at > Time.now
    end
  end

  def price_is_highest
    unless auction.blank? || price.blank? || accepted
      errors.add(:price, '入札額が最高金額ではありません') if auction.first_price >= price
      errors.add(:price, '入札額が最高金額ではありません') if auction.bids.maximum(:price).to_i >= price
    end
  end
end
