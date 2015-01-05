class CreateEvaluations < ActiveRecord::Migration
  def change
    create_table :evaluations do |t|
      t.integer :evaluater_id
      t.integer :evaluatee_id
      t.text :comment

      t.timestamps
    end

    add_index :evaluations, :evaluater_id
    add_index :evaluations, :evaluatee_id
    add_index :evaluations, [:evaluater_id, :evaluatee_id], unique: true
  end
end
