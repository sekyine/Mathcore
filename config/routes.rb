Rails.application.routes.draw do
  get "user_cards/index"
  get "gacha/draw"
  get "static_pages/home"

  get "up" => "rails/health#show", as: :rails_health_check

  root 'static_pages#home'
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  get '/draw', to: 'gacha#draw'
  resources :user_cards, path: 'cards'
end
