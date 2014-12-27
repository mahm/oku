class CreateAuctions < ActiveRecord::Migration
  def change
    create_table :auctions do |t|
      t.references :item, index: true
      t.references :user, index: true
      t.datetime :open_at
      t.datetime :close_at
      t.integer :first_price
      t.integer :highest_price
      t.boolean :closed

      t.timestamps
    end
  end
end
