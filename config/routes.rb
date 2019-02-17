Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  post 'users/authentication', to: 'authentication#create'
  get 'users/activation', to: 'account_activations#edit'

  resources :users, only: %i[create]
  resources :password_resets, only: %i[create edit update]
end
