class Item < ActiveRecord::Base
  belongs_to :user
  belongs_to :category

  validates :user_id, presence: true
  validates :category_id, presence: true
  validates :name, presence: true
end
