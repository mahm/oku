class AddIndexToEvaluations < ActiveRecord::Migration
  def change
    add_index :evaluations,
              [:auction_id, :evaluater_id, :evaluatee_id],
              unique: true,
              name: 'index_unique_evaluation'
  end
end
