Rails.application.routes.draw do
  resources :items

  root to: 'home#index'

  devise_for :users
end
