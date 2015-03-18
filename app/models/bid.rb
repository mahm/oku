class Bid < ActiveRecord::Base
  belongs_to :auction
  belongs_to :user

  validates :auction_id, presence: true
  validates :user_id, presence: true
  validates :price, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}

  validate :auction_is_in_time, if: 'auction_id.present?'
  validate :price_is_highest, if: 'auction.present? && price.present? && !accepted'

  private

  def auction_is_in_time
    errors.add(:auction_id, 'オークションは終了しています') if auction.closed && !accepted
    errors.add(:auction_id, 'オークションは準備中です') if auction.open_at > Time.now
  end

  def price_is_highest
    errors.add(:price, '入札額が最高金額ではありません') if auction.first_price >= price
    errors.add(:price, '入札額が最高金額ではありません') if auction.bids.maximum(:price).to_i >= price
  end
end
