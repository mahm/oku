class User < ActiveRecord::Base
  has_many :owned_auctions, class_name: 'Auction' # 自分が開催しているオークション
  has_many :bids
  has_many :bidding_auctions, through: :bids, source: :auction # 他人が開催し、自分が入札しているオークション
  has_many :evaluations, foreign_key: 'evaluater_id', dependent: :destroy
  has_many :evaluatees, through: :evaluations
  has_many :reverse_evaluations, foreign_key: 'evaluatee_id', class_name: 'Evaluation', dependent: :destroy
  has_many :evaluaters, through: :reverse_evaluations

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def evaluate?(other_user)
    evaluations.find_by(evaluatee_id: other_user.id)
  end

  def evaluate!(other_user, comment)
    evaluations.create!(evaluatee_id: other_user.id, comment: comment)
  end
end
