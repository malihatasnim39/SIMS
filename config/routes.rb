Rails.application.routes.draw do
  # Root route
  root "financial_records#expenseDashboard"

  # Financial Records Routes
  resources :financial_records, only: [ :create, :edit, :update, :index, :show, :destroy ] do
    collection do
      get :expenseForm, as: :expense_form
      get :expenseDashboard
      get :super_club_expenses
      get :sub_club_expenses
    end

    member do
      get :all_super_expenses
      get :all_sub_expenses
      get :expense_details
      get :delete_confirmation
    end
  end

  # Equipment Routes
  resources :equipments do
    member do
      get :club_info
    end
  end

  # Health Check
  get "up" => "rails/health#show", as: :rails_health_check
end
