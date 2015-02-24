class RemoveHighestPriceFromAuction < ActiveRecord::Migration
  def change
    remove_column :auctions, :highest_price, :integer
  end
end
