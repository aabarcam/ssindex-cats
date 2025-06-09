Rails.application.routes.draw do
  resource :session
  resource :user, only: [ :new, :create ]
  # resources :passwords, param: :token
  get "cat_facts/index"
  get "likes/index", to: "likes#index", as: :index_likes
  post "likes/create", to: "likes#create", as: :create_likes
  delete "likes/destroy", to: "likes#destroy", as: :destroy_likes

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "cat_facts#index"
end
