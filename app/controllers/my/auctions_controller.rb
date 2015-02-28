class My::AuctionsController < My::ApplicationController
  before_action :set_auction, only: %i(show edit update)

  def index
  end

  def show
  end

  def new
    @auction = current_user.owned_auctions.build
  end

  def create
    @auction = current_user.owned_auctions.build(auction_params)
    respond_to do |format|
      if @auction.save
        format.html { redirect_to my_auctions_path, notice: "新規オークション「#{@auction.title}」が作成されました。" }
      else
        format.html { render :new }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @auction.update(auction_params)
        format.html { redirect_to my_auctions_path, notice: "「#{@auction.title}」が変更されました。" }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
  end

  private

  def auction_params
    params.require(:auction).permit(
        :title,
        :amount,
        :category_id,
        :open_at,
        :close_at,
        :first_price,
        :closed,
        :explanation
    )
  end

  def set_auction
    @auction = current_user.owned_auctions.find(params[:id])
  end
end
