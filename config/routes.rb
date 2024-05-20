Rails.application.routes.draw do
  root 'home#index'

  # Devise routes
  devise_for :users, controllers: { sessions: 'custom_sessions' }

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
  end
  
  # Registration routes
  resources :registrations, only: [:new]
  get '/line_registration', to: 'registrations#line_registration', as: :line_registration
  get '/email_registration', to: 'registrations#email_registration', as: :email_registration

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end