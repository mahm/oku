module FeatureHelper
  def sign_in(user, password = 'xxx')
    visit root_path
    click_on 'サインイン'
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: password
    click_button 'サインイン'
  end

  def create_auction_start_1year_after_end_2year_after(auctioneer)
    sign_in(auctioneer)
    click_on 'マイ・オークション'
    click_on 'オークションの新規作成'
    select Category.all.sample.name, from: 'カテゴリ'
    fill_in 'タイトル', with: "#{Time.now} に作成したオークション"
    fill_in '開始価格', with: '1'
    select "#{(Time.now+1.year).year}", from: 'auction[open_at(1i)]'
    select "#{(Time.now+2.year).year}", from: 'auction[close_at(1i)]'
    click_on '登録する'
    click_on 'サインアウト'
  end

  def bid(auction, bidder, price)
    sign_in(bidder)
    visit polymorphic_path([auction.category, auction])
    click_on '入札する'
    fill_in '入札額', with: price
    click_on '入札'
    click_on 'サインアウト'
  end
end