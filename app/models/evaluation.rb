class Evaluation < ActiveRecord::Base
  belongs_to :evaluater, class_name: 'User'
  belongs_to :evaluatee, class_name: 'User'

  validates :evaluater_id, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :evaluatee_id, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
