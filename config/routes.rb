Rails.application.routes.draw do
  root "financial_records#expenseDashboard"
  resources :financial_records, only: [ :create, :edit, :update, :index, :show, :destroy ] do
    collection do
      get "expenseForm", to: "financial_records#expenseForm", as: :expense_form
      get "expenseDashboard"
    end
    member do
      get "expense_details"
    end
    member do
      get "delete_confirmation", to: "financial_records#delete_confirmation"
    end
  end


  resources :equipments do
    get "club_info", on: :member
  end



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
