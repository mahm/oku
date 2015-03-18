class My::AuctionsController < My::ApplicationController
  before_action :set_auction, only: %i(show edit update destroy)

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
    @auction.destroy
    respond_to do |format|
      format.html { redirect_to [:my, :auctions], notice: 'オークションを削除しました。' }
    end
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
        :explanation,
        :picture
    )
  end

  def set_auction
    @auction = current_user.owned_auctions.find_by_id(params[:id])
    @auction ||= current_user.bidded_auctions.find(params[:id])
  end
end
