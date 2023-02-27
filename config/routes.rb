require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  post '/users/confirm_email' => 'users#confirm_email'

  concern :votable do
    post :vote, on: :member
  end

  concern :commentable do
    resources :comments, shallow: true, only: [:create]
  end

  resources :questions, concerns: [:votable, :commentable] do
    member do
      delete :destroy_file
    end
    resources :answers, shallow: true, only: [:create, :update, :new, :destroy], concerns: [:votable, :commentable] do
      member do
        post :mark_as_best
        delete :destroy_file
      end
    end
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions, only: %i[index show update create destroy] do
        resources :answers, shallow: true, only: %i[index show update create destroy]
      end
    end
  end

  resources :rewards, only: [:index]
  resources :links, only: [:destroy]
  root to: "questions#index"

  mount ActionCable.server => '/cable'
end
