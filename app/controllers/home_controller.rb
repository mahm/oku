class HomeController < ApplicationController
  def index
    @auctions = Auction.opened
  end
end
