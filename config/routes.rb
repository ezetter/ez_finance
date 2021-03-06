Rails.application.routes.draw do

  devise_for :users
  resources :accounts
  resources :account_types
  resources :account_owners
  resources :account_history, :only => [:index]

  get 'analysis/future' => 'portfolio_analysis#future_value'
  get 'analysis/breakdown' => 'portfolio_analysis#breakdown'
  post 'accounts/bulk_update' => 'accounts#bulk_update'

  root to: "accounts#index"

end
