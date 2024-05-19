Rails.application.routes.draw do
  resources :sessions, only: [] do
    collection do
      get :new, path: '/login'
      post :create, path: '/login'
      get :destroy, path: '/logout'
      get :login_with_line, as: :line_login
    end
  end
  
  resources :calendars, only: [:index, :show, :new, :create, :edit]
  resources :schedules, only: [:new, :create, :edit, :update, :destroy]
  resources :exercises, only: [:index, :show] do
    collection do
      get :autocomplete
    end
  end
  
  resources :users, only: [:new, :create, :show] do
    collection do
      post :line_callback
    end
  end
  
  post '/callback', to: 'line_bot#callback'
  get '/auth/:provider/callback', to: 'sessions#create'
  get 'line_registration', to: 'users#line_registration', as: :line_registration
  get 'email_registration', to: 'users#email_registration', as: :email_registration
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end