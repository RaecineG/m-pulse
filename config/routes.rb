Rails.application.routes.draw do
  # get 'comments/index'
  # get 'comments/new'
  # get 'comments/create'
  # get 'checkins/index'
  # get 'checkins/create'
  # get 'checkins/destroy'
  # get 'events/index'
  # get 'events/show'
  # get 'events/new'
  # get 'events/create'
  # get 'events/edit'
  # get 'events/update'
  # get 'events/destroy'
  # get 'events/recommended'
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get '/events/recommended', to: 'events#recommended', as: 'recommended'
  resources :events do
    resources :checkins, only: [:index, :create]
    resources :comments, only: [:index, :new, :create]
  end
  resources :checkins, only: [:destroy]
end
