Rails.application.routes.draw do
  root 'home#index'
  resources :users, only: [:create, :new, :show, :update]
  get '/users/:email_token/confirm_email', to: 'users#confirm_email', as: 'confirm_user_email'

  resources :events, only: [:new, :create, :show, :index]
  resources :stories, only: [:new, :create, :show, :index]
  resources :artworks, only: [:new, :create, :show, :index]
  resources :submissions, only: [:index]
  put '/submissions', to: 'submissions#update', as: 'update_submissions'

  namespace :admin do
    resources :submissions, only: [:index]
    get '/unowned_submissions', to: 'submissions#show', as: 'unowned_submissions'
    put '/submissions', to: 'submissions#update', as: 'update_submissions'
    put '/unowned_submissions', to: 'submissions#update'
    resources :users, only: [:new]
    put '/users', to: 'users#update'
  end

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
end
