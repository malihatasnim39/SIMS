Rails.application.routes.draw do
  resources :borrowings do
    collection do
      get :super_club_borrowings
      get :sub_club_borrowings
    end
  end

  root "borrowings#index"
end
