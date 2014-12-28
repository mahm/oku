class CreateBids < ActiveRecord::Migration
  def change
    create_table :bids do |t|
      t.references :auction, index: true, null: false
      t.references :user, index: true, null: false
      t.integer :price, null: false

      t.timestamps
    end
  end
end
