Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"
  # Defines the root path route ("/")
  root to: "home#index"

  # Endpoints using resources
  resources :users
  resources :medications
  resources :prescriptions

  # Other get method routes
  get 'prescriptions/history/:patient_id', to: 'prescriptions#history'
  get "up" => "rails/health#show", as: :rails_health_check
  get "/secret", to: "secret#index"

  # Other post method routes
  post "/login", to: "auth#login"
end
