Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: { passwords: 'passwords', registrations: 'registrations' }

  get 'welcome/index'
  root 'welcome#index'

  resources :users, :dashboard

  get 'users/profile', to: 'users#show', as: 'profile'
  get 'users/profile/edit', to: 'users#edit', as: 'edit_profile'
  patch 'users/profile/update', to: 'users#update', as: 'update_profile'

  get 'news_and_info', to: 'dashboard#news_and_info', as: 'news_and_info'
  get 'contact_us', to: 'dashboard#contact_us', as: 'contact_us'
  get 'message_sent', to: 'dashboard#message_sent', as: 'message_sent'
  post 'send_message', to: 'dashboard#send_message', as: 'send_message'

  devise_scope :user do
    get '/passwords/sent'
  end

  get '404', to: 'errors#not_found'
  get '500', to: 'errors#internal_server_error'

  resources :consent, only: :index
  put 'consent-form', to: 'consent#update'
  get 'consent-form', to: 'consent#edit'

  get 'counselor-will-contact', to: 'counselor_contact#show'
end
