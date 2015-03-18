require 'rails_helper'

RSpec.describe User, :type => :model do
  describe 'validate user data' do
    it 'is valid with a valid email address and password made by 8 or more characters' do
      expect(build(:user)).to be_valid
    end

    it 'is invalid without a email address' do
      user = build(:user, email: nil)
      user.valid?
      expect(user.errors[:email]).not_to be_empty
    end

    it 'is invalid with a invalid email address' do
      user = build(:user, email: 'This is not a email address')
      user.valid?
      expect(user.errors[:email]).not_to be_empty
    end

    it 'is invalid without a password' do
      user = build(:user, password: nil)
      user.valid?
      expect(user.errors[:password]).not_to be_empty
    end
  end

  describe 'count accepted auctions' do
    it do
      auction_count = 2
      auctioneer = create(:user)
      bidder = create(:user)
      (1..auction_count).each { create(:auction, user_id: auctioneer.id) }
      travel 2.hour
      auctioneer.owned_auctions.each { |auction| create(:bid, user_id: bidder.id, auction_id: auction.id, price: 1) }
      travel 24.hour
      auctioneer.owned_auctions.each { |auction| auction.accept_and_close }
      expect(bidder.accepted_auctions.count).to eq auction_count
    end
  end
end
