class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # 終了日時を過ぎているオークションを終了し、落札処理を行います。
  # 本来は Controller に入れるべき処理ではないですが、コードレビュー専用アプリなので
  # このような実装にしました。
  # 本来は whenever などを使って行うべきでしょうか...
  # → そうですね、恐らく通常は日次バッチで行うのかなーと思います
  before_action :close_auction

  def close_auction
    Auction.must_be_close.each do |auction|
      # Auction#accept_and_close内でsave!を使っているので、例外を捕捉するようにしないといけませんね
      # if auction.accept_and_close
      #   Rails.logger.info("オークション ID #{auction.id} を終了しました")
      # else
      #   Rails.logger.error("オークション ID #{auction.id} の終了処理が失敗しました")
      # end
      begin
        auction.accept_and_close
        Rails.logger.info "[CLOSE_AUCTION] close auction_id: #{auction.id}"
      rescue ActiveRecord::RecordInvalid => e
        Rails.logger.error "[CLOSE_AUCTION][ERROR] cannot close auction_id: #{auction.id}, #{e.class}: #{e.message}"
      end
    end
  end
end
