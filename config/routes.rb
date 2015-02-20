Rails.application.routes.draw do
  get 'bids/index'

  get 'bids/new'

  get 'bids/create'

  get 'bids/destroy'

  root to: 'home#index'

  devise_for :users

  resources :auctions, only: %i(index show) do
    resources :bids, only: %i(index new create destroy)
  end

  namespace :my do
    resources :auctions
  end
end
