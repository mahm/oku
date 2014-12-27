class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.references :user, index: true
      t.references :category, index: true
      t.string :name
      t.text :explanation

      t.timestamps
    end
  end
end
