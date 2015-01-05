class User < ActiveRecord::Base
  has_many :items
  has_many :auctions
  has_many :bids
  has_many :evaluations, foreign_key: 'evaluater_id', dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
