Rails.application.routes.draw do
  root to: 'home#index'

  devise_for :users

  resources :auctions, only: %i(index show) do
    resources :bids, only: %i(index new create)
  end

  namespace :my do
    resources :auctions
  end
end
