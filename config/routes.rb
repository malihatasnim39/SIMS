Rails.application.routes.draw do
  resources :borrowings
# Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

# Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
# Can be used by load balancers and uptime monitors to verify that the app is live.
resources :borrowings
get "up" => "rails/health#show", as: :rails_health_check

 get "/signup", to: "auth#new"
  post "/signup", to: "auth#sign_up"
  get "/signin", to: "auth#signin_new"
  post "/signin", to: "auth#sign_in"
  delete "/signout", to: "auth#sign_out"
  get "/signed_in", to: "auth#signed_in"
end
