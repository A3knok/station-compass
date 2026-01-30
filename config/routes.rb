Rails.application.routes.draw do
  # 開発環境のみメール確認画面を表示
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  # CI / LoadBalancer 用のヘルスチェック
  get "/healthz", to: proc { [ 200, {}, [ "OK" ] ] }

  # DeviseをUserモデルに適用する
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    password: "users/password"
  }

  devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#guest_sign_in"
  end

  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "static_pages#index"
  get "privacy_policy", to: "privacy_policies#privacy_policy"

  resources :users, only: %i[show]

  resources :stations, only: %i[index] do
    # 駅は以下のルート一覧
    resources :routes, only: %i[index]
    # 駅に属するランキング
    get "ranks", to: "ranks#index"
  end

  resources :routes, except: %i[index] do
    resource :helpful_marks, only: %i[create destroy]
  end

  resources :contacts, only: %i[new create]
end
