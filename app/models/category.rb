class Category < ActiveRecord::Base
  has_many :items

  validates :code, presence: true, uniqueness: true
  validates :name, presence: true
end
