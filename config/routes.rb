Rails.application.routes.draw do
  # Auth routes
  get "/signup", to: "auth#new"
  post "/signup", to: "auth#sign_up"
  get "/signin", to: "auth#signin_new"
  post "/signin", to: "auth#sign_in"
  delete "/signout", to: "auth#sign_out"
  get "/signed_in", to: "auth#signed_in"

  # Dashboard routes
  get "supervisor/dashboard", to: "supervisor#dashboard", as: :supervisor_dashboard
  get "PIC/dashboard", to: "pic#dashboard", as: :pic_dashboard

  # Root route (redirect to sign-in if not authenticated)
  root to: "auth#signin_new"

  # Add your other routes here (expenses, reports, etc.)
end
