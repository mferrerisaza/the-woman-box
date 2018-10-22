Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:show]
  root to: 'pages#home'
  resources :orders, only: [:index, :new, :create] do
    resources :payments, only: [:new, :create]
  end
  resources :plans, only: :index
  resources :sizes, only: :index

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
