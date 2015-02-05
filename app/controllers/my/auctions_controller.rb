class My::AuctionsController < My::ApplicationController

  def index
  end

  def show
  end

  def new
    @auction = current_user.auctions.build
  end

  def create
    @auction = current_user.auctions.build(auction_params)
    respond_to do |format|
      if @auction.save
        format.html { redirect_to my_auction_path, notice: 'オークションが作成されました。' }
      else
        format.html { render :new }
      end
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def auction_params
    params.require(:auction).permit(
        :title,
        :item_name,
        :amount,
        :category_id,
        :open_at,
        :close_at,
        :first_price,
        :closed,
    )
  end
end
