Rails.application.routes.draw do
  get "static_pages/home"

  get "up" => "rails/health#show", as: :rails_health_check

  root 'static_pages#home'
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  
end
