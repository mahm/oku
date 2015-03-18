class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :rememberable, :validatable

  has_many :bids
  # 自分が開催しているオークション
  has_many :owned_auctions, class_name: 'Auction'
  # 他人が開催し、自分が入札しているオークション
  has_many :bidded_auctions, through: :bids, source: :auction
  # 自分が他人に対して行った評価
  has_many :evaluations, foreign_key: 'evaluater_id', dependent: :destroy
  # 他人が自分に対して行った評価
  has_many :reverse_evaluations, foreign_key: 'evaluatee_id', class_name: 'Evaluation', dependent: :destroy
  # 出品（被評価）者
  has_many :evaluatees, through: :evaluations
  # 評価（落札）者
  has_many :evaluaters, through: :reverse_evaluations

  def accepted_auctions
    Bid.where(accepted: true, user_id: self.id).inject(Array.new) { |auctions, bid| auctions<<bid.auction }
  end
end
