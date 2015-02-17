class AddExplanationToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :explanation, :text
  end
end
