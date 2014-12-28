require 'rails_helper'

RSpec.describe Bid, :type => :model do
  it 'is invalid without a auction_id' do
    bid = build(:bid, auction_id: nil)
    bid.valid?
    expect(bid.errors[:auction_id]).to include("can't be blank")
  end

  it 'is invalid without a user_id' do
    bid = build(:bid, user_id: nil)
    bid.valid?
    expect(bid.errors[:user_id]).to include("can't be blank")
  end

  it 'is invalid without a price' do
    bid = build(:bid, price: nil)
    bid.valid?
    expect(bid.errors[:price]).to include("can't be blank")
  end

  it 'is invalid when price is less than 0' do
    bid = build(:bid, price: -1)
    bid.valid?
    expect(bid.errors[:price]).to include("must be greater than or equal to 0")
  end

  it 'is valid with a auction_id, user_id, price and auction is in time' do
    auction = create(:auction, open_at: Time.now + 1.day, close_at: Time.now + 3.day)
    bidder = create(:user)
    travel 2.day
    bid = Bid.new(auction_id: auction.id, user_id: bidder.id, price: 1)
    bid.valid?
    expect(bid).to be_valid
  end

  it 'is invalid when auction is over' do
    auction = create(:auction, open_at: Time.now + 1.day, close_at: Time.now + 3.day)
    bidder = create(:user)
    travel 3.day
    bid = Bid.new(auction_id: auction.id, user_id: bidder.id, price: 1)
    bid.valid?
    expect(bid.errors[:auction_id]).to include("auction is over")
  end

  it 'is invalid when auction is not open' do
    auction = create(:auction, open_at: Time.now + 1.day, close_at: Time.now + 3.day)
    bidder = create(:user)
    bid = Bid.new(auction_id: auction.id, user_id: bidder.id, price: 1)
    bid.valid?
    expect(bid.errors[:auction_id]).to include("auction is not open")
  end
end
