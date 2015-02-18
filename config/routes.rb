Rails.application.routes.draw do
  root to: 'home#index'

  devise_for :users

  resources :auctions, only: %i(index show)

  namespace :my do
    resources :auctions
  end
end
