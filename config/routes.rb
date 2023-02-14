Rails.application.routes.draw do
  devise_for :users

  concern :votable do
    post :vote, on: :member
  end

  resources :questions, concerns: [:votable] do
    member do
      delete :destroy_file
    end
    resources :answers, shallow: true, only: [:create, :update, :new, :destroy], concerns: [:votable] do
      member do
        post :mark_as_best
        delete :destroy_file
      end
    end
  end

  resources :rewards, only: [:index]
  resources :links, only: [:destroy]
  root to: "questions#index"

end
