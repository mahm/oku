Rails.application.routes.draw do
  root to: 'home#index'

  devise_for :users

  # get 'auctions', to: 'auctions#index'
  resources :auctions, only: [:index]
end
