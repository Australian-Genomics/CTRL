Rails.application.routes.draw do
  devise_for :users, controllers: { passwords: 'passwords', registrations: 'registrations' }
  resources :users, :dashboard
    get "step_one", to: "consent#step_one", as: "step_one"
    get "step_two", to: "consent#step_two", as: "step_two"
  devise_scope :user do
    get '/passwords/sent'
  end
  get 'welcome/index'
  root 'welcome#index'
end  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.htmlend