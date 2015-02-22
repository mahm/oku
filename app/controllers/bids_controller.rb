class BidsController < ApplicationController
  before_action :set_auction

  def index
    @bids = @auction.bids.order('price DESC').all
  end

  def new
    @bid = @auction.bids.build
  end

  def create
    @bid = @auction.bids.build(bid_params)
    @bid.user_id = current_user.id
    respond_to do |format|
      if @bid.save
        format.html { redirect_to @bid.auction, notice: "#{@bid.price} 円で入札しました。" }
      else
        format.html { render :new }
      end
    end
  end

  private

  def bid_params
    params.require(:bid).permit(:price)
  end

  def set_auction
    @auction = Auction.find(params[:auction_id])
  end
end
