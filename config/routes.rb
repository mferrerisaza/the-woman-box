Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:show]
  root to: 'pages#home'
  resources :orders, except: [:delete] do
    resources :payments, only: [:new, :create]
    post 'payments/cancel', to: "payments#cancel"
  end
  resources :plans, only: :index
  resources :sizes, only: :index
end
