Rails.application.routes.draw do
  resources :contas

  resources :usuarios do
    get :gerar_cpf, on: :collection, format: :json
    get :usuario_por_cpf, on: :collection, format: :json
    get :movimentacao, on: :member, format: :json
    get :encerrar_conta, on: :member
  end

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'sign_out' => 'sessions#destroy'

  root 'home#index'
end
