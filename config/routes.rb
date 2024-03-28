Rails.application.routes.draw do
  get 'cart_items/create'
  get 'carts/show'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root to: 'products#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :products, only: [:show, :index]
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  get 'about', to: 'pages#about'
  get 'contact', to: 'pages#contact'
  get 'categories/:id/products', to: 'categories#show', as: 'category_products'
  get 'products/:id', to: 'products#show'


  # Defines the root path route ("/")
  # root "posts#index"
end
