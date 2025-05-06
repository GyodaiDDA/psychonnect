Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

  # Endpoints using resources
  resources :users
  resources :medications
  resources :prescriptions

  # Other get method routes
  get "prescriptions/history/:patient_id", to: "prescriptions#history"
  get "up" => "rails/health#show", as: :rails_health_check
  get "/secret", to: "secret#index"

  # Other methods routes
  post "/login", to: "auth#login"
  patch "users/:id/role", to: "users#update_role"
end
