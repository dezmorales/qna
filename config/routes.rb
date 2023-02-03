Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    member do
      delete :destroy_file
    end
    resources :answers, shallow: true, only: [:create, :update, :new, :destroy] do
      member do
        post :mark_as_best
        delete :destroy_file
      end
    end
  end

  resources :links, only: [:destroy]
  root to: "questions#index"

end
