class Category < ActiveRecord::Base
  has_many :auctions

  validates :code, presence: true, uniqueness: true
  validates :name, presence: true
end
