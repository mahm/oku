namespace :sampledata do
  desc 'サンプルデータ生成'
  task generate: :environment do
    User.delete_all
    User.create(email: 'a@b.com', password: 'xxx')
    User.create(email: 'c@d.com', password: 'xxx')
    User.create(email: 'e@f.com', password: 'xxx')
    Auction.delete_all
    # 準備中のオークション
    Auction.create(title: '準備中 あああ いいい ううう えええ おおお',
                   user_id: User.all.sample.id,
                   first_price: (1..1000).to_a.sample,
                   open_at: Time.now + 1.day,
                   close_at: Time.now + 2.day,
                   category_id: Category.all.sample.id)
    # 実施中のオークション
    (1..3).each do |n|
      Auction.create(title: "実施中 #{n} あああ いいい ううう えええ おおお",
                     user_id: User.all.sample.id,
                     first_price: (1..1000).to_a.sample,
                     open_at: Time.now,
                     close_at: Time.now + 1.day,
                     category_id: Category.all.sample.id)
    end
  end
end
