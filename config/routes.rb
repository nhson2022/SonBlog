Rails.application.routes.draw do
  root "pages#home"
  resources :articles
  resources :categories

  devise_for :users
end
