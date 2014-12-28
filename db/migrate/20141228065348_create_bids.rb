class CreateBids < ActiveRecord::Migration
  def change
    create_table :bids do |t|
      t.references :auction, index: true
      t.references :user, index: true
      t.integer :price

      t.timestamps
    end
  end
end
