class AddPointToEvaluations < ActiveRecord::Migration
  def change
    add_column :evaluations, :point, :integer, default: 0
  end
end
