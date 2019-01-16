Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :users
  resources :users, only: [:show]
  root to: 'pages#home'
  resources :orders, except: [:delete] do
    resources :payments, only: [:new, :create]
    collection do
      get 'thank_you'
    end
    get '/payments/one_off', to: "payments#unique_payment", as: :unique_payment
    post 'payments/cancel', to: "payments#cancel"
  end
  get 'select_plan', to: "plans#select_plan", as: :select_plan
  resources :plans, only: :index
  resources :sizes, only: :index
  get 'privacy_policy', to: "pages#privacy_policy", as: :privacy_policy
  get 'terms_and_conditions', to: "pages#terms_and_conditions", as: :terms_and_conditions
  get 'referral_program', to: "pages#referral_program", as: :referral_program
  require "sidekiq/web"
  authenticate :user, lambda { |u| u.admin } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
