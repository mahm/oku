require 'rails_helper'

feature '入札処理', type: :feature do
  before(:each) do
    @auctioneer = create(:user, password: 'xxx')
    @bidder = create(:user, password: 'xxx')
    create(:category)
    create_auction_start_1year_after_end_2year_after(@auctioneer)
    travel 1.year
  end

  context '自分が開催しているオークションで' do
    scenario '入札できない' do
      sign_in(@auctioneer)
      visit polymorphic_path([Auction.last.category, Auction.last])
      expect(page).to have_content('入札はできません')
      expect(page).not_to have_link('入札する')
    end
  end

  context '他人が開催しているオークションで' do
    context '1 件目の入札の場合' do
      before(:each) do
        sign_in(@bidder)
        visit polymorphic_path([Auction.last.category, Auction.last])
        click_on '入札する'
      end
      context '入札額がオークションの開始価格より高い場合' do
        scenario '入札できる' do
          fill_in '入札額', with: Auction.last.first_price+1
          click_on '入札'
          expect(current_path).to eq(polymorphic_path([Auction.last.category, Auction.last]))
          expect(page).to have_content('入札しました')
          expect(Auction.last.highest_price).to eq(Bid.last.price)
        end
      end
      context '入札額がオークションの開始価格以下の場合' do
        scenario '入札できない' do
          fill_in '入札額', with: Auction.last.first_price
          click_on '入札'
          expect(current_path).to eq(polymorphic_path([Auction.last.category, Auction.last, :bids]))
          expect(page).to have_content('最高金額ではありません')
          expect(Bid.all.count).to eq(0)
        end
      end
    end
    context '2 件名以降の入札の場合' do
      before(:each) do
        sign_in(@bidder)
        visit polymorphic_path([Auction.last.category, Auction.last])
        click_on '入札する'
        fill_in '入札額', with: Auction.last.first_price+1
        click_on '入札'
        click_on 'サインアウト'
        another_bidder = create(:user, password: 'xxx')
        sign_in(another_bidder)
        visit polymorphic_path([Auction.last.category, Auction.last])
        click_on '入札する'
      end
      context '入札額がこれまでの最高額の場合' do
        scenario '入札できる' do
          expect{
            fill_in '入札額', with: Auction.last.bids.order(:price).last.price+1
            click_on '入札'
          }.to change(Bid, :count).from(1).to(2)
          expect(current_path).to eq(polymorphic_path([Auction.last.category, Auction.last]))
          expect(page).to have_content('入札しました')
          expect(Auction.last.highest_price).to eq(Bid.last.price)
        end
      end
      context '入札額が最高額ではない場合' do
        scenario '入札できない' do
          fill_in '入札額', with: Auction.last.bids.order(:price).last.price
          click_on '入札'
          expect(current_path).to eq(polymorphic_path([Auction.last.category, Auction.last, :bids]))
          expect(page).to have_content('最高金額ではありません')
        end
      end
    end
  end
end
