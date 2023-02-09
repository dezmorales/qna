Rails.application.routes.draw do
  devise_for :users

  concern :votable do
    post :vote, on: :member
  end

  resources :questions do
    member do
      delete :destroy_file
    end
    concerns :votable
    resources :answers, shallow: true, only: [:create, :update, :new, :destroy] do
      member do
        post :mark_as_best
        delete :destroy_file
      end
      concerns :votable
    end
  end

  resources :rewards, only: [:index]
  resources :links, only: [:destroy]
  root to: "questions#index"

end
