class RemoveIndexFromEvaluations < ActiveRecord::Migration
  def change
    remove_index :evaluations, [:evaluater_id, :evaluatee_id]
  end
end
