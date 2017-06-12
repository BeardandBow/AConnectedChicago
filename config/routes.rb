Rails.application.routes.draw do
  root 'home#index'

  get '/resources', to: 'home#resources', as: 'resources'
  get '/about', to: 'home#about', as: 'about'

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      get '/neighborhoods/:name', to: "neighborhoods#show" do
        resources :events
        resources :stories
        resources :artworks
      end
      get '/organizations', to: "organizations#index" do
        resources :organizations
      end
    end
  end

  resources :charges, only: [:create, :new]

  resources :users, only: [:create, :new, :show, :edit, :update]
  get '/users/:email_token/confirm_email', to: 'users#confirm_email', as: 'confirm_user_email'

  resources :events, only: [:new, :create, :show, :destroy]
  resources :stories, only: [:new, :create, :show, :destroy]
  resources :artworks, only: [:new, :create, :show, :destroy]
  resources :submissions, only: [:index]
  put '/submissions', to: 'submissions#update', as: 'update_submissions'

  namespace :admin do
    resources :submissions, only: [:index]
    get '/unowned_submissions', to: 'submissions#show', as: 'unowned_submissions'
    put '/submissions', to: 'submissions#update', as: 'update_submissions'
    put '/unowned_submissions', to: 'submissions#update'
    resources :users, only: [:new]
    put '/users', to: 'users#update'
    resources :types, only: [:index, :create, :destroy]
    resources :organizations, only: [:index, :create, :show, :edit, :update, :destroy]
  end

  namespace :admin, as: '' do
    get '/organizations/:id/edit_locations', to: "organizations#edit_locations", as: 'edit_admin_organization_locations'
  end

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
end
