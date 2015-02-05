class AddCategoryIdToAuctions < ActiveRecord::Migration
  def change
    add_reference :auctions, :category, index: true
  end
end
