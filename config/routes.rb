Rails.application.routes.draw do
  root to: 'home#index'

  devise_for :users

  resources :users, only: %i() do
    resources :evaluations, only: %i(index)
  end

  resources :category, only: %i() do
    resources :auctions, only: %i(index show) do
      resources :bids, only: %i(index new create)
      resources :evaluations
    end
  end

  namespace :my do
    resources :auctions
    resources :evaluations, only: %i(index)
  end
end
