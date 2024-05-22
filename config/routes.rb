Rails.application.routes.draw do
  get 'static_pages/privacy_policy'
  get 'static_pages/terms_of_service'
  root 'home#index'

  # Devise routes
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations',
    unlocks: 'users/unlocks',
  }

  authenticated :user do
    get '/profile', to: 'users#profile', as: :authenticated_root
  end

  # Custom session routes
  resources :sessions, only: [] do
    collection do
      get :new, path: '/login'
      post :create, path: '/login'
      get :destroy, path: '/logout'
      get :login_with_line, as: :line_login
    end
  end

  # User profile route
  devise_scope :user do
    get '/choose_registration', to: 'users/registrations#choose', as: :choose_registration
    get '/profile', to: 'users#profile', as: :user_profile
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
  get '/line_registration', to: 'line_users#line_registration', as: :line_registration
  get '/email_registration', to: 'registrations#email_registration', as: :email_registration


  # LineUsers routes
  resources :line_users, only: [:show, :new, :create]

  # Customize routes
  resource :customize, only: [:edit, :update]

  # Bookmarks route
  resources :bookmarks, only: [:index]

  # Static pages routes
  scope controller: :static_pages do
    get :privacy_policy
    get :terms_of_service
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end