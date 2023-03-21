Rails.application.routes.draw do
  root "pages#home"
  get '/about' => 'pages#about', as: :pages_about
  resources :articles
  resources :categories

  devise_for :users
end
