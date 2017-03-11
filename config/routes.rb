Rails.application.routes.draw do
  root 'home#index'
  resources :users, only: [:create, :new, :show]
  resources :events, only: [:new, :create, :show]
  resources :stories, only: [:new, :create, :show]
  resources :artworks, only: [:new, :create, :show]
  resources :submissions, only: [:index]
  namespace :admin do
    resources :submissions, only: [:index]
    put '/submissions', to: 'submissions#update' as: "admin_update_submissions"
  end

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  patch '/submissions', to: 'submissions#update', as: "update_submissions"

end
