class HomeController < ApplicationController
  def index
    redirect_to auctions_path
  end
end
