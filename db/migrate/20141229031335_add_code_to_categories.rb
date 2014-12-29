class AddCodeToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :code, :integer
    add_index :categories, :code, unique: true
  end
end
