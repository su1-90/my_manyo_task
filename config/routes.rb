Rails.application.routes.draw do
  resources :users
  namespace :admin do
    resources :users
  end
  resources :sessions, only: [:create, :destroy], except: [:new]
  resources :tasks

  get '/login', to: 'sessions#new', as: 'new_session'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy', as: 'logout'

  root 'tasks#index'

  # 500エラーページ表示用
  get 'raise_error', to: 'application#raise_error'
end