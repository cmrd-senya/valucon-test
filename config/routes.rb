Rails.application.routes.draw do
  root 'home#index'
  resources :feedbacks, only: :create
end
