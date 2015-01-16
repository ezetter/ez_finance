Rails.application.routes.draw do

  resources :accounts
  resources :account_types
  resources :account_owners
  resources :account_history, :only => [:index]
  resources :admin, :only => [:index]

  get 'analysis/future' => 'portfolio_analysis#future_value'
  get 'analysis/breakdown' => 'portfolio_analysis#breakdown'
  post 'accounts/bulk_update' => 'accounts#bulk_update'

  root to: "accounts#index"

end
