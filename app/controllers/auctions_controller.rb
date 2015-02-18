class AuctionsController < ApplicationController
  before_action :set_auction, only: %i(show)

  def index
    @auctions = Auction.opened.all
  end

  def show
  end

  private

  def set_auction
    @auction = Auction.find(params[:id])
  end
end
