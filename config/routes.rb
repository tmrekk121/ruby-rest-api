Rails.application.routes.draw do
  get 'users/:user_id', to: 'users#index'
  patch 'users/:user_id', to: 'users#update'
  post 'signup', to: 'users#signup'
  post 'close', to: 'users#signout'
end
