Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: { passwords: 'passwords', registrations: 'registrations' }

  get 'welcome/index'
  root 'welcome#index'

  resources :users, :dashboard, :steps

  get "users/profile", to: "users#show", as: "profile"
  get "users/profile/edit", to: "users#edit", as: "edit_profile"
  patch "users/profile/update", to: "users#update", as: "update_profile"

  get "step_one", to: "consent#step_one", as: "step_one"
  get "step_two", to: "consent#step_two", as: "step_two"
  get "step_three", to: "consent#step_three", as: "step_three"
  get "step_four", to: "consent#step_four", as: "step_four"
  get "step_five", to: "consent#step_five", as: "step_five"

  get "news_and_info", to: "dashboard#news_and_info", as: "news_and_info"
  get "contact_us", to: "dashboard#contact_us", as: "contact_us"
  get 'message_sent', to: 'dashboard#message_sent', as: 'message_sent'
  post 'send_message', to: "dashboard#send_message", as: "send_message"

  get "confirm_answers", to: "consent#confirm_answers", as: "confirm_answers"
  get "review_answers", to: "consent#review_answers", as: "review_answers"
  get "notification_consent", to: "consent#notification_consent", as: "notification_consent"

  devise_scope :user do
    get '/passwords/sent'
  end

  get '404', to: 'errors#not_found'
  get '500', to: 'errors#internal_server_error'

  # Refactored Routes

  resources :consent_refactor, only: [:update]
  get 'consent-form', to: 'consent_refactor#edit'
end
