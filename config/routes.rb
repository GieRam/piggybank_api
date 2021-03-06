# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  resources :users, only: %i[create] do
    collection do
      post 'authentication', to: 'authentication#create'
      delete 'authentication', to: 'authentication#destroy'
      get 'activation', to: 'account_activations#edit'
      post 'field/validation', to: 'users#validate_field'
    end
  end
  resources :password_resets, only: %i[create edit update]
  resources :transactions, only: %i[index]
  resources :accounts do
    collection do
      post 'field/validation', to: 'accounts#validate_field'
    end
  end
end
