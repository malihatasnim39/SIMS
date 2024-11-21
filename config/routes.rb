Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  get "/signup", to: "auth#new"
  post "/signup", to: "auth#sign_up"
  get "/signin", to: "auth#signin_new"
  post "/signin", to: "auth#sign_in"
  delete "/signout", to: "auth#sign_out"
  get "/signed_in", to: "auth#signed_in"
  get "club_created", to: "clubs#club_created"

  resources :clubs, only: [ :new, :create, :index, :edit, :update, :destroy ]
end
