class AddItemNameAndAmountToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :item_name, :string
    add_column :auctions, :amount, :integer, null: false, default: 1
  end
end
