class Bid < ActiveRecord::Base
  belongs_to :auction
  belongs_to :user

  validates :auction_id, presence: true
  validates :user_id, presence: true
  validates :price, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}

  validate :auction_is_in_time, if: 'auction_id.present?'
  validate :price_is_highest, if: 'auction.present? && price.present? && !accepted'

  scope :only_accepted, -> { where(accepted: true) }

  private

  def auction_is_in_time
    errors.add(:auction_id, 'オークションは終了しています') if auction.close? && !accepted
    errors.add(:auction_id, 'オークションは準備中です') if auction.in_ready?
  end

  def price_is_highest
    errors.add(:price, '入札額が最高金額ではありません') unless auction.biddable_price?(price)
  end
end
