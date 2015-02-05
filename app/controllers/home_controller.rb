class HomeController < ApplicationController
  def index
    if user_signed_in?
      redirect_to my_auctions_path
    else
      redirect_to auctions_path
    end
  end
end
