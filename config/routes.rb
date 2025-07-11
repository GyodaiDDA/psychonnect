Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  # Endpoints using resources
  resources :users, only: %i[show create update]
  resources :medications, only: %i[index show create]
  resources :prescriptions, only: %i[index show create]
  namespace :admin do
    resources :users, only: %i[index show create update destroy]
    resources :medications, only: %i[update destroy]
    resources :prescriptions, only: %i[destroy]
  end

  # Other get method routes
  get 'treatment/history/:patient_id', to: 'prescriptions#history'
  get 'treatment/current/:patient_id', to: 'prescriptions#index'
  get 'up' => 'rails/health#show', as: :rails_health_check
  get '/secret', to: 'secret#index'

  # Other methods routes
  post '/login', to: 'auth#login'
  patch 'users/:id/role', to: 'users#update_role'
end
