Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    resources :answers, shallow: true, only: [:create, :update, :new, :destroy] do
      member do
        post :mark_as_best
      end
    end
  end

  root to: "questions#index"

end
