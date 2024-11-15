Rails.application.routes.draw do
  get 'static_pages/privacy_policy'
  get 'static_pages/terms_of_service'
  root 'calendars#new'

  # Devise routes
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations',
    unlocks: 'users/unlocks',
  }

  # Custom session routes
  devise_scope :user do
    get '/login', to: 'users/sessions#new', as: :new_line_user_session
    post '/login', to: 'users/sessions#create'
    get '/logout', to: 'users/sessions#destroy', as: :destroy_line_user_session
    get '/line_login', to: 'sessions#line_login', as: :login_with_line
  end

  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: redirect('/')

  # User profile route
  authenticated :user do
    get '/choose_registration', to: 'users/registrations#choose', as: :choose_registration
    get '/profile', to: 'users#profile', as: :user_profile
  end
  
  # Calendar routes
  resources :calendars, except: [:destroy, :update] do
    resources :schedules, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  end

  # Exercise routes
  resources :exercises, only: [:index, :show] do
    collection do
      get :autocomplete
    end
    resources :bookmarks, only: [:create, :destroy], shallow: false
  end
  
  # Registration routes
  resources :registrations, only: [:new]
  get '/line_registration', to: 'line_users#line_registration', as: :line_registration
  get '/email_registration', to: 'registrations#email_registration', as: :email_registration

  # LineUsers routes
  resources :line_users, only: [:show, :new, :create]

  # Customize routes
  resources :customizes, only: [:new, :edit, :create, :update]

  # Bookmarks route
  resources :bookmarks, only: [:index]

  # Static pages routes
  scope controller: :static_pages do
    get :privacy_policy
    get :terms_of_service
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end