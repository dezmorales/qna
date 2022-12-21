Rails.application.routes.draw do
  resources :questions do
    resources :answers, shallow: true, only: [:create, :new]
  end
end
