namespace :auction_task do

  desc '終了日時を過ぎたオークションを終了する'

  task close: :environment do
    Auction.must_be_close.each do |auction|
      auction.closed = true
      if auction.save
        Rails.logger.info("オークション ID #{auction.id} を終了しました")
      else
        Rails.logger.error("オークション ID #{auction.id} の終了処理が失敗しました")
      end
    end
  end
end
