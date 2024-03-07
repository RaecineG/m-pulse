Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get '/events/recommended', to: 'events#recommended', as: 'recommended'
  get '/dashboard', to: 'events#dashboard', as: 'dashboard'
  get '/events/:id/details', to: 'events#details', as: 'details'
  get '/follows', to: 'events#follows', as: 'follows'
  get '/friends', to: 'events#friends', as: 'friends'
  post '/follow/:user_id/:follow', to: 'events#follow_user'
  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all

  resources :events do
    resources :checkins, only: [:index, :create]
    resources :comments, only: [:index, :create]
  end
  resources :checkins, only: [:destroy]
end
