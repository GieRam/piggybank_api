Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :accounts, except: [:destroy]
  resources :users, only: %i[show create update]
  resources :goals, except: [:destroy]
  resources :tags, only: %i[index show create]
  resources :transactions, only: %i[index show create]
end
