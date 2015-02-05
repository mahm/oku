class AddTitleToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :title, :string
  end
end
