Rails.application.routes.draw do
  root "root#index"
  namespace :dashboard do
    resources :subscribe_servers, only: [ :index, :show, :edit, :update, :destroy ]
  end
  get "/dashboard", to: "dashboard#index"
  mount MissionControl::Jobs::Engine, at: "/jobs"

  resource :inbox, only: :create
  resource :actor, only: :show
  get "/.well-known/webfinger", to: "webfinger#show"

  scope path: ".well-known" do
    scope module: :wellknown do
      get "nodeinfo", to: "nodeinfo#show"
    end
  end

  get "/nodeinfo/2.1", to: "nodeinfo#show"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
