Rails.application.routes.draw do
  post '/admin/signup', to: 'admin_auth#signup'
  post '/admin/login', to: 'admin_auth#login'

  post '/trader/signup', to: 'trader_auth#signup'
  post '/trader/login', to: 'trader_auth#login'

  namespace :admin do
    resources :traders, only: [:index, :show, :create, :update]
  end
end
