class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # 終了日時を過ぎているオークションを終了し、落札処理を行います。
  # 本来は Controller に入れるべき処理ではないですが、コードレビュー専用アプリなので
  # このような実装にしました。
  # 本来は whenever gem などを使って行うべきでしょうか...
  before_action :close_auction

  def close_auction
    Auction.must_be_close.each do |auction|
      if auction.accept_and_close
        Rails.logger.info("オークション ID #{auction.id} を終了しました")
      else
        Rails.logger.error("オークション ID #{auction.id} の終了処理が失敗しました")
      end
    end
  end
end
