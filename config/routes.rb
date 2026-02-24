Rails.application.routes.draw do
  resources :documentos
  root "documentos#index"
  get "up" => "rails/health#show", as: :rails_health_check
end
