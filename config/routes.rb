Rails.application.routes.draw do
  resources :calendars, only: [:index, :show, :new, :create, :edit]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
