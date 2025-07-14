Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  # Pages routes
  root "pages#home"
  get "how-to-use", to: "pages#howtouse", as: :how_to_use
  get "contribution", to: "pages#contribution"
  
  # Component documentation routes
  get "components/tab", to: "components#tab"
  get "components/button", to: "components#button"
  get "components/accordion", to: "components#accordion"
  get "components/switch", to: "components#switch"
  get "components/tooltip", to: "components#tooltip"
  get "components/dropdown", to: "components#dropdown"
  get "components/icon", to: "components#icon"
  get "components/input", to: "components#input"
  get "components/badge", to: "components#badge"
  get "components/select", to: "components#select"
  get "components/textarea", to: "components#textarea"
end
