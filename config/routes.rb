Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  # Endpoints using resources
  resources :users, only: %i[index show create update]
  resources :medications
  resources :prescriptions
  namespace :admin do
    resources :users, only: %i[index create update destroy]
  end

  # Other get method routes
  get 'prescriptions/history/:patient_id', to: 'prescriptions#history'
  get 'up' => 'rails/health#show', as: :rails_health_check
  get '/secret', to: 'secret#index'

  # Other methods routes
  post '/login', to: 'auth#login'
  patch 'users/:id/role', to: 'users#update_role'
end
