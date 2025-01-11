Rails.application.routes.draw do
  # Borrowings routes
  resources :borrowings, except: [:show] do
    collection do
      get :super_club_borrowings
      get :sub_club_borrowings
    end
  end

  # Routes for balance sheet and notifications
  get "balance_sheet/:id", to: "borrowings#balance_sheet", as: "borrowing_balance_sheet"
  get "borrowings/notification", to: "borrowings#notification", as: "borrowing_notification"

  # Equipments stock route
  get "/equipments/:id/stock", to: "equipments#stock"

  # Notifications routes
  resources :notifications, only: [:index, :show] do
    member do
      post :resend
    end
  end

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check

  # Uncomment these if Progressive Web App (PWA) functionality is needed
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Root route (if needed, uncomment and adjust accordingly)
  # root "posts#index"
end
