Rails.application.routes.draw do
  post '/admin/signup', to: 'admin_auth#signup'
  post '/admin/login', to: 'admin_auth#login'

  post '/trader/signup', to: 'trader_auth#signup'
  post '/trader/login', to: 'trader_auth#login'

  post '/buy_stock', to: 'traders#buy_stock'
  post '/buy', to: 'transactions#buy'

  namespace :admin do
    resources :traders, only: [:index, :show, :create, :update]
  end

  resources :stocks, only: [:index, :show]
  post '/refresh_stocks', to: 'stocks#refresh'
end
