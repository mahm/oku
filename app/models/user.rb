class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :rememberable, :validatable

  has_many :bids
  has_many :owned_auctions, class_name: 'Auction' # 自分が開催しているオークション
  has_many :bidding_auctions, through: :bids, source: :auction # 他人が開催し、自分が入札しているオークション
  has_many :evaluations, foreign_key: 'evaluater_id', dependent: :destroy
  has_many :evaluatees, through: :evaluations
  has_many :reverse_evaluations, foreign_key: 'evaluatee_id', class_name: 'Evaluation', dependent: :destroy
  has_many :evaluaters, through: :reverse_evaluations

  def accepted_auctions
    auctions = []
    Bid.where(accepted: true, user_id: self.id).each do |bid|
      auctions<<bid.auction
    end
    auctions
  end
end
