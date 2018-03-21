Rails.application.routes.draw do
  devise_for :users, controllers: { passwords: 'passwords' }
  resources :users, :dashboard, :consent
  devise_scope :user do
    get '/passwords/sent'
  end
  get 'welcome/index'
  root 'welcome#index'
end  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.htmlend