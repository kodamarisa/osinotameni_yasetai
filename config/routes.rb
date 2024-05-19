Rails.application.routes.draw do
  post '/callback', to: 'line_bot#callback'
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  resources :calendars, only: [:index, :show, :new, :create, :edit]
  resources :schedules, only: [:new, :create, :edit, :update, :destroy]
  resources :exercises, only: [:index, :show] do
    collection do
      get :autocomplete
    end
  end

  resources :users, only: [:new, :create, :show]
  post '/line_callback', to: 'users#line_callback'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
