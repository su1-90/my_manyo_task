Rails.application.routes.draw do
  namespace :admin do
    resources :users
  end
  resources :users, only: [:new, :create, :show, :edit, :update, :destroy]
  resources :sessions, only: [:create, :destroy], except: [:new]
  resources :tasks

  get '/login', to: 'sessions#new', as: 'new_session' # ログイン画面へのルート
  post '/login', to: 'sessions#create' # ログインアクションへのルート
  delete '/logout', to: 'sessions#destroy', as: 'logout' # ログアウトアクションへのルート

  root 'tasks#index'
end