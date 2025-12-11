Rails.application.routes.draw do
  # DeviseをUserモデルに適用する
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
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
  resources :routes, only: %i[new show create index edit update destroy]
end
