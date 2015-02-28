class AuctionsController < ApplicationController
  before_action :set_category
  before_action :set_auction, only: %i(show)

  def index
    @auctions = @category.auctions.opened
  end

  def show
  end

  private

  def set_auction
    @auction = @category.auctions.find(params[:id])
  end

  def set_category
    @category = Category.find(params[:category_id])
  end
end
