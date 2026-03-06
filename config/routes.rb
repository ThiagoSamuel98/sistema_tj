Rails.application.routes.draw do
  # Página inicial
  root "dashboard#index"
  
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
  
  # Dashboard
  get "dashboard", to: "dashboard#index", as: :dashboard
  
  # Recursos principais com aninhamento
  resources :indicadores do
    resources :serie_historicas, only: [:index, :new, :create], as: :historico
    resources :metas, only: [:index, :new, :create], as: :metas
  end
  
  resources :serie_historicas
  resources :metas
  resources :documentos
end
