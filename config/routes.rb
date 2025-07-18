Rails.application.routes.draw do
  get "user_cards/index"
  get "gacha/draw"
  get "static_pages/home"

  get "up" => "rails/health#show", as: :rails_health_check

  get 'gacha/redraw', to: 'gacha#redraw', as: 'redraw'
  get 'gacha/draw_ten', to: 'gacha#draw_ten', as: 'draw_ten' # この行を追加
  root 'static_pages#home'
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  get '/draw', to: 'gacha#draw'

  get 'dungeons/select', to: 'dungeons#select', as: 'dungeon_select'


  post '/gemini', to: 'gemini#generate_content'
  get '/gemini', to: 'gemini#generate_content'
  get 'gemini/test', to: 'gemini#test'
  resources :user_cards, path: 'cards'
  resources :battles, only: [:new, :create, :show] do
    post :play, on: :member
    collection do
      post :start_investigation
    end
  end
  resource :battle_investigate, only: [:new] do
    post :answer, on: :collection
  end
  post 'cards/answer', to: 'cards#answer', as: :answer_card
  namespace :admin do
    resources :cards, only: [:index] do
      collection do
        post :import_csv
      end
    end
  end
  resources :users, only: [] do
    collection do
      get 'options'    # GET /users/options → 設定画面表示
      patch 'update_settings'  # PATCH /users/update_settings → 設定保存
    end
  end
end

