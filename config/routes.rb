Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :accounts
  resources :users
  resources :goals
  resources :tags
  resources :transactions
end
