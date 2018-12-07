Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :users
  resources :users, only: [:show]
  root to: 'pages#home'
  resources :orders, except: [:delete] do
    resources :payments, only: [:new, :create]
    post 'payments/cancel', to: "payments#cancel"
  end
  resources :plans, only: :index
  resources :sizes, only: :index
  get 'privacy_policy', to: "pages#privacy_policy", as: :privacy_policy
  get 'terms_and_conditions', to: "pages#terms_and_conditions", as: :terms_and_conditions
  require "sidekiq/web"
  authenticate :user, lambda { |u| u.admin } do
    mount Sidekiq::Web => '/sidekiq'
  end
  get 'deliveries', to: "pages#deliveries", as: :deliveries
end
