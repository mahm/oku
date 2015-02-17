class RemoveItemNameFromAuctions < ActiveRecord::Migration
  def change
    remove_column :auctions, :item_name, :string
  end
end
