Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  post 'authenticate', to: 'authentication#create'

  resources :users, only: %i[create]
  resources :account_activations, only: [:edit]
  resources :password_resets, only: %i[create edit update]
end
