Rails.application.routes.draw do
  root to: 'home#index'

  devise_for :users

  resources :auctions, only: [:index]

  namespace :my do
    resources :auctions, only: [:index, :show, :create, :edit, :update, :destroy]
  end
end
