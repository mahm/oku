require 'rails_helper'

RSpec.describe Auction, :type => :model do
  it 'is valid with a item_id, open_at, close_at, first_price' do
    expect(build(:auction)).to be_valid
  end

  it 'is invalid without a open_at' do
    auction = build(:auction, open_at: nil)
    auction.valid?
    expect(auction.errors[:open_at]).not_to be_empty
  end

  it 'is invalid without a close_at' do
    auction = build(:auction, close_at: nil)
    auction.valid?
    expect(auction.errors[:close_at]).not_to be_empty
  end

  it 'is invalid without a first_price' do
    auction = build(:auction, first_price: nil)
    auction.valid?
    expect(auction.errors[:first_price]).not_to be_empty
  end

  it 'is invalid without a title' do
    auction = build(:auction, title: nil)
    auction.valid?
    expect(auction.errors[:title]).not_to be_empty
  end

  it 'is invalid without a amount' do
    auction = build(:auction, amount: nil)
    auction.valid?
    expect(auction.errors[:amount]).not_to be_empty
  end

  it 'is invalid when close time is past of open itme' do
    auction = build(:auction, close_at: Time.now - 1.day, open_at: Time.now)
    auction.valid?
    expect(auction.errors[:close_at]).not_to be_empty
  end

  it 'is invalid when open time is past' do
    auction = build(:auction, open_at: Time.now - 1.minute)
    auction.valid?
    expect(auction.errors[:open_at]).not_to be_empty
  end

  describe 'オークション終了処理' do
    context '入札が 1 件以上存在する場合' do
      before(:each) do
        @auction = create(:auction, open_at: Time.now+1.hour, close_at: Time.now+2.hour)
        @bidder = create(:user)
        travel 1.hour
        create(:bid, auction_id: @auction.id, user_id: @bidder.id, price: @auction.first_price+1)
        create(:bid, auction_id: @auction.id, user_id: @bidder.id, price: @auction.bids.order(:price).last.price+1)
        travel 2.hour
        @auction.accept_and_close
      end
      it 'closed が true となる' do
        expect(@auction.closed).to be_truthy
      end
      it '最高入札額が落札価格となる' do
        highest_bid = @auction.bids.order(:price).last
        expect(highest_bid.accepted).to be_truthy
        expect(@auction.accepted_price).to eq(highest_bid.price)
      end
      it '最高額を入札した user が落札者となる' do
        expect(@auction.accepted_by?(@bidder.id)).to be_truthy
      end
    end
  end
end
