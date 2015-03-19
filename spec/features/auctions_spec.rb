require 'rails_helper'

feature 'オークション', type: :feature do
  given!(:auctioneer) { create(:user, password: 'xxx') }

  before(:each) do
    sign_in(auctioneer)
    click_on 'マイ・オークション'
    click_on 'オークションの新規作成'
  end

  feature '新規作成処理' do
    context 'カテゴリ, タイトル, 開始価格の全てが入力されている' do
      before(:each) do
        select Category.all.sample.name, from: 'カテゴリ'
        fill_in 'タイトル', with: "#{Time.now} に作成したオークション"
        fill_in '開始価格', with: '1'
      end
      context '開始日時が現在以降で, 終了日時が開始日時以降' do
        scenario '処理は正常に完了し, 準備中としてマイ・オークションの一覧に表示される' do
          expect{
            select "#{(Time.now+1.year).year}", from: 'auction[open_at(1i)]'
            select "#{(Time.now+2.year).year}", from: 'auction[close_at(1i)]'
            click_on '登録する'
          }.to change(Auction, :count).to(1)
          expect(current_path).to eq(polymorphic_path([:my, :auctions]))
          expect(page).to have_table('auctions-in-ready')
          expect(find('#auctions-in-ready')).to have_content(Auction.last.title)
          expect(find('#auctions-in-ready')).to have_link('詳細表示')
        end
      end
      context '開始日時が現在以前' do
        scenario '処理はエラーとなる' do
          select "#{(Time.now+2.year).year}", from: 'auction[close_at(1i)]'
          click_on '登録する'
          expect(Auction.count).to eq(0)
          expect(current_path).to eq(polymorphic_path([:my, :auctions]))
        end
      end
      context '終了日時が開始日時以前' do
        scenario '処理はエラーとなる' do
          select "#{(Time.now+1.year).year}", from: 'auction[open_at(1i)]'
          click_on '登録する'
          expect(Auction.count).to eq(0)
          expect(current_path).to eq(polymorphic_path([:my, :auctions]))
        end
      end
    end
    context 'カテゴリが入力（選択）されていない' do
      scenario '処理はエラーとなる' do
        fill_in 'タイトル', with: "#{Time.now} に作成したオークション"
        fill_in '開始価格', with: '1'
        select "#{(Time.now+1.year).year}", from: 'auction[open_at(1i)]'
        select "#{(Time.now+2.year).year}", from: 'auction[close_at(1i)]'
        click_on '登録する'
        expect(Auction.count).to eq(0)
        expect(current_path).to eq(polymorphic_path([:my, :auctions]))
      end
    end
    context 'タイトルが入力されていない' do
      scenario '処理はエラーとなる' do
        select Category.all.sample.name, from: 'カテゴリ'
        fill_in 'タイトル', with: ''
        fill_in '開始価格', with: '1'
        select "#{(Time.now+1.year).year}", from: 'auction[open_at(1i)]'
        select "#{(Time.now+2.year).year}", from: 'auction[close_at(1i)]'
        click_on '登録する'
        expect(Auction.count).to eq(0)
        expect(current_path).to eq(polymorphic_path([:my, :auctions]))
      end
    end
    context '開始価格が入力されていない' do
      scenario '処理はエラーとなる' do
        select Category.all.sample.name, from: 'カテゴリ'
        fill_in 'タイトル', with: "#{Time.now} に作成したオークション"
        fill_in '開始価格', with: ''
        select "#{(Time.now+1.year).year}", from: 'auction[open_at(1i)]'
        select "#{(Time.now+2.year).year}", from: 'auction[close_at(1i)]'
        click_on '登録する'
        expect(Auction.count).to eq(0)
        expect(current_path).to eq(polymorphic_path([:my, :auctions]))
      end
    end
    context '開始価格に数値以外が入力されている' do
      scenario '処理はエラーとなる' do
        select Category.all.sample.name, from: 'カテゴリ'
        fill_in 'タイトル', with: "#{Time.now} に作成したオークション"
        fill_in '開始価格', with: 'あいうえお'
        select "#{(Time.now+1.year).year}", from: 'auction[open_at(1i)]'
        select "#{(Time.now+2.year).year}", from: 'auction[close_at(1i)]'
        click_on '登録する'
        expect(Auction.count).to eq(0)
        expect(current_path).to eq(polymorphic_path([:my, :auctions]))
      end
    end
  end
end
