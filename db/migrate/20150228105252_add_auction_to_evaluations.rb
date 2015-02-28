class AddAuctionToEvaluations < ActiveRecord::Migration
  def change
    add_reference :evaluations, :auction, index: true
  end
end
