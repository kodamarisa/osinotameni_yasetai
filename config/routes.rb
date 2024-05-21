Rails.application.routes.draw do
  get 'customize/edit'
  get 'customize/update'
  root 'home#index'

  # Devise routes
  devise_for :users, controllers: {
    sessions: 'custom_sessions',
    registrations: 'users/registrations'
   }

  # Custom session routes
  resources :sessions, only: [] do
    collection do
      get :new, path: '/login'
      post :create, path: '/login'
      get :destroy, path: '/logout'
      get :login_with_line, as: :line_login
    end
  end
  
  # Calendar routes
  resources :calendars, only: [:index, :show, :new, :create, :edit]
  
  # Schedule routes
  resources :schedules, only: [:new, :create, :edit, :update, :destroy]
  
  # Exercise routes
  resources :exercises, only: [:index, :show] do
    collection do
      get :autocomplete
    end
    resources :bookmarks, only: [:create, :destroy], shallow: true
  end
  
  # Registration routes
  resources :registrations, only: [:new]
  get '/line_registration', to: 'registrations#line_registration', as: :line_registration
  get '/email_registration', to: 'registrations#email_registration', as: :email_registration

  # Add the following routes for line_users and users
  resources :line_users, only: [:show], path: '/line_users'
  resources :users, only: [], path: '/users' do
    member do
      get :profile
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end