Rails.application.routes.draw do
  get 'home/index'

  devise_for :users
end
