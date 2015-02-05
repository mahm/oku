class RemoveItemIdFromAuctions < ActiveRecord::Migration
  def change
    remove_column :auctions, :item_id, :integer
  end
end
