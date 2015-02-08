class AuctionsController < ApplicationController
  def index
    @auctions = Auction.opened.all
  end
end
