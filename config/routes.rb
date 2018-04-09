Rails.application.routes.draw do
  devise_for :users, controllers: { passwords: 'passwords', registrations: 'registrations' }
  resources :users, :dashboard

    get "step_one", to: "consent#step_one", as: "step_one"
    get "step_two", to: "consent#step_two", as: "step_two"
    get "step_three", to: "consent#step_three", as: "step_three"
    get "step_four", to: "consent#step_four", as: "step_four"
    get "step_five", to: "consent#step_five", as: "step_five"

    get "about_us", to: "dashboard#about_us", as: "about_us"

    post "confirm_answers", to: "consent#confirm_answers", as: "confirm_answers"
    post "review_answers", to: "consent#review_answers", as: "review_answers"

  devise_scope :user do
    get '/passwords/sent'
  end
  get 'welcome/index'
  root 'welcome#index'
end  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.htmlend