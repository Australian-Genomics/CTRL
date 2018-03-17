Rails.application.routes.draw do
  devise_for :users
  resources :users
  get 'welcome/index'
  root 'welcome#index'
end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.htmlend