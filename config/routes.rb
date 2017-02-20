Rails.application.routes.draw do
  root 'home#index'
  resources :feedbacks, only: :create
  resources :photos, only: %i(create index)
  get '{{photo.url}}' => 'home#index' # Workaround for a weird angular issue
end
