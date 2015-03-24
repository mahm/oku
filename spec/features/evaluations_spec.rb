require 'rails_helper'

RSpec.feature '評価', type: :feature do
  before(:each) do
    @auctioneer = create(:user, password: 'xxx')
    @bidder_lose = create(:user, password: 'xxx')
    @bidder_win = create(:user, password: 'xxx')
    create_auction_start_1year_after_end_2year_after(@auctioneer)
    travel 1.year
    bid(Auction.last, @bidder_lose, Auction.last.first_price+1)
    bid(Auction.last, @bidder_win, Auction.last.highest_price+1)
    travel 2.year
    visit root_path # 落札処理
  end

  context '落札者の場合' do
    before(:each) do
      sign_in(@bidder_win)
      visit polymorphic_path([:my, :auctions])
    end
    scenario 'マイ・オークションの落札一覧に落札したオークションが表示される' do
      expect(page).to have_table('auctions-accepted')
      expect(page).to have_content(Auction.last.title)
    end
    scenario '評価は落札者、出品者、その他全てのユーザーが閲覧可能となる' do
      comment = %Q(これはコメントです。\n迅速に対応いただきまして、ありがとうございました。)
      click_on '詳細表示'
      expect(current_path).to eq(polymorphic_path([:my, Auction.last]))
      expect(page).to have_content('あなたが落札')
      click_on '出品者を評価する'
      expect(current_path).to eq(polymorphic_path([:new, Auction.last.category, Auction.last, :evaluation]))
      expect{
        choose %w(良い 悪い).sample
        fill_in '出品者へのコメントがあれば入力してください', with: comment
        click_on '評価登録'
      }.to change(Evaluation, :count).to(1)
      expect(page).to have_content('評価しました')
      expect(page).to have_selector('#evaluation')
      expect(page).to have_content(Auction.last.title)
      expect(page).to have_content(Auction.last.user.email)
      expect(page).to have_content(Auction.last.successful_bidder)
      expect(page).to have_content(comment)
      expect(page).to have_link('訂正')
      expect(page).to have_link('取消')
    end
  end

  context '落札者以外の入札者の場合' do
    before(:each) do
      sign_in(@bidder_lose)
      visit polymorphic_path([:my, :auctions])
    end
    scenario 'マイ・オークションには落札できなかったオークションは表示されない' do
      expect(page).not_to have_table('auctions-accepted')
    end
  end
end
