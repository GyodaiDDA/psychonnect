Rails.application.routes.draw do
  # Endpoints using resources
  resources :users
  resources :medications
  resources :prescriptions
  
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root to: "home#index"
end
