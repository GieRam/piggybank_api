Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  post 'authenticate', to: 'authentication#authenticate'

  resources :users, only: %i[create]
  resources :password_resets, only: %i[create update]
end
