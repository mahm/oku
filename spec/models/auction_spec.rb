require 'rails_helper'

RSpec.describe Auction, :type => :model do
  it 'is valid with a item_id, open_at, close_at, first_price' do
    expect(build(:auction)).to be_valid
  end

  it 'is invalid without a item_id' do
    auction = build(:auction, item_id: nil)
    auction.valid?
    expect(auction.errors[:item_id]).to include("can't be blank")
  end

  it 'is invalid without a open_at' do
    auction = build(:auction, open_at: nil)
    auction.valid?
    expect(auction.errors[:open_at]).to include("can't be blank")
  end

  it 'is invalid without a close_at' do
    auction = build(:auction, close_at: nil)
    auction.valid?
    expect(auction.errors[:close_at]).to include("can't be blank")
  end

  it 'is invalid without a first_price' do
    auction = build(:auction, first_price: nil)
    auction.valid?
    expect(auction.errors[:first_price]).to include("can't be blank")
  end

  it 'is invalid without a title' do
    auction = build(:auction, title: nil)
    auction.valid?
    expect(auction.errors[:title]).to include("can't be blank")
  end

  it 'is invalid when close time is past of open itme' do
    auction = build(:auction, close_at: Time.now - 1.day, open_at: Time.now)
    auction.valid?
    expect(auction.errors[:close_at]).to include("invalid close time")
  end

  it 'is invalid when open time, close time is in the past' do
    auction = build(:auction, open_at: Time.now - 2.day, close_at: Time.now - 1.day)
    auction.valid?
    expect(auction.errors[:open_at]).to include("open time can't be in the past")
    expect(auction.errors[:close_at]).to include("close time can't be in the past")
  end
end
