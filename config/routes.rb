Rails.application.routes.draw do
  resources :calendars, only: [:index, :show, :new, :create, :edit]
  resources :schedules, only: [:new, :create, :edit, :update, :destroy]
  resources :exercises, only: [:index]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
