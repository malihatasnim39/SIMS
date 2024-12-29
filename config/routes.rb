Rails.application.routes.draw do
  resources :borrowings, except: [ :show ] do
    collection do
      get :super_club_borrowings
      get :sub_club_borrowings
    end
  end

  get "balance_sheet/:id", to: "borrowings#balance_sheet", as: "borrowing_balance_sheet"
end
