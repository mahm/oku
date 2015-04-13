require 'rails_helper'

feature 'オークション', type: :feature do
  given!(:auctioneer) { create(:user, password: 'xxx') }

  feature '新規作成処理' do
    before(:each) do
      create(:category)
      sign_in(auctioneer)
      click_on 'マイ・オークション'
      click_on 'オークションの新規作成'
    end
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

  feature '更新' do
    before(:each) do
      create(:category)
      create_auction_start_1year_after_end_2year_after(auctioneer)
      sign_in(auctioneer)
    end
    scenario '準備中のオークションを更新' do
      visit polymorphic_path([:my, :auctions])
      expect(page).to have_table('auctions-in-ready')
      click_link '詳細表示'
      expect(current_path).to eq(polymorphic_path([:my, Auction.last]))
      click_link '編集'
      expect(current_path).to eq(polymorphic_path([:edit, :my, Auction.last]))
      new_title = '更新後のオークションのタイトル'
      fill_in 'タイトル', with: new_title
      click_button '更新する'
      expect(page).to have_content(new_title)
    end
  end

  feature '開始' do
    before(:each) do
      create(:category)
      create_auction_start_1year_after_end_2year_after(auctioneer)
      travel 1.year
      sign_in(auctioneer)
    end
    context '開始日時を過ぎた場合' do
      scenario 'マイ・オークションの「出品中」の一覧に表示される' do
        visit polymorphic_path([:my, :auctions])
        expect(find('#auctions-opened')).to have_content(Auction.last.title)
      end
      scenario 'トップページににも表示される' do
        visit root_path
        expect(find('.auction')).to have_content(Auction.last.title)
      end
      scenario 'カテゴリ別ページににも表示される' do
        visit root_path
        click_link Auction.last.category.name
        expect(current_path).to eq(polymorphic_path([Auction.last.category, :auctions]))
        expect(find('.auction')).to have_content(Auction.last.title)
      end
    end
  end

  feature '終了と落札' do
    before(:each) do
      create(:category)
      create_auction_start_1year_after_end_2year_after(auctioneer)
      @bidder = create(:user, password: 'xxx')
      travel 1.year
      sign_in(@bidder)
      visit polymorphic_path([Auction.last.category, Auction.last])
      click_on '入札する'
      fill_in '入札額', with: Auction.last.first_price+1
      click_on '入札'
      click_on 'サインアウト'
      travel 2.year
      visit polymorphic_path([Auction.last.category, Auction.last])
    end
    context '終了日時以降の場合' do
      scenario 'オークションは終了している' do
        expect(page).to have_content('終了')
        expect(page).not_to have_content('あなたが落札しました')
        expect(page).not_to have_content('出品者を評価する')
      end
      context '落札者の場合' do
        before(:each) do
          sign_in(@bidder)
          visit polymorphic_path([Auction.last.category, Auction.last])
        end
        scenario '自分が落札した事が表示される' do
          expect(page).to have_content('あなたが落札しました')
        end
        scenario '出品者を評価するボタンが表示される' do
          expect(page).to have_content('出品者を評価する')
        end
      end
    end
  end
end
