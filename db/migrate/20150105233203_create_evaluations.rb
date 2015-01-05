class CreateEvaluations < ActiveRecord::Migration
  def change
    create_table :evaluations do |t|
      t.integer :evaluater_id
      t.integer :evaluatee_id
      t.text :comment

      t.timestamps
    end
  end
end
