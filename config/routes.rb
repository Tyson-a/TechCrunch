Rails.application.routes.draw do
  # Devise setup for user and admin authentication
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # Root route
  root to: 'products#index'

  # Products and Categories
  resources :products, only: [:show, :index]
  get 'categories/:id/products', to: 'categories#show', as: 'category_products'

  # Cart and Cart Items
  resource :cart, only: [:show] do
    post 'checkout', on: :member
  end

  resources :cart_items, only: [:create, :update, :destroy]

  # Orders
  resources :orders, only: [:show, :new, :create]
  # config/routes.rb
  get 'stripe_auto_post', to: 'carts#stripe_auto_post', as: 'stripe_auto_post'
  get 'order/cancel', to: 'orders#cancel', as: 'order_cancel'
  post 'create_stripe_session', to: 'checkout#create_stripe_session'
  # Users and Provinces
  resources :users, only: [:show, :edit, :update] do
    get 'orders', on: :member, as: 'order_history'
  end
  resources :provinces

  # Static Pages
  get 'about', to: 'pages#about'
  get 'contact', to: 'pages#contact'

  # Health Check
  get "up" => "rails/health#show", as: :rails_health_check



end
