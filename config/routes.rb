Rails.application.routes.draw do
  root 'home#index'
  resources :users, only: [:create, :new, :show]
  resources :events, only: [:new, :create, :show, :index]
  resources :stories, only: [:new, :create, :show, :index]
  resources :artworks, only: [:new, :create, :show, :index]
  resources :submissions, only: [:index]

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  put '/submissions', to: 'submissions#update', as: "update_submissions"
end
