Rails.application.routes.draw do
  resources :usuarios

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'sign_out' => 'sessions#destroy'

  root 'home#index'
end
