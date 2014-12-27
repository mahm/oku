class CreateAuctions < ActiveRecord::Migration
  def change
    create_table :auctions do |t|
      t.references :item, index: true, null: false
      t.references :user, index: true, null: false
      t.datetime :open_at, null: false
      t.datetime :close_at, null: false
      t.integer :first_price, null: false, default: 0
      t.integer :highest_price, null: false, default: 0
      t.boolean :closed, null: false, default: false

      t.timestamps
    end
  end
end
