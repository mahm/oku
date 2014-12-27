class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.references :user, index: true, null: false
      t.references :category, index: true, null: false
      t.string :name, null: false
      t.text :explanation

      t.timestamps
    end
  end
end
