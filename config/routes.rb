Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config.merge(
    controllers: { sessions: 'admin/sessions' }
  )

  post '/admin/import_export', to: 'admin/import_export#post'
  ActiveAdmin.routes(self)
  devise_for :users, controllers: { passwords: 'passwords', registrations: 'registrations', sessions: 'users/sessions' }

  get 'welcome/index'
  root 'welcome#index'

  resources :users, :dashboard
  resources :consent, only: :index
  resources :survey_responses, only: :index

  get 'users/profile', to: 'users#show', as: 'profile'
  get 'users/profile/edit', to: 'users#edit', as: 'edit_profile'
  patch 'users/profile/update', to: 'users#update', as: 'update_profile'

  get 'glossary', to: 'glossary_entries#show', as: 'glossary'

  get 'news_and_info', to: 'dashboard#news_and_info', as: 'news_and_info'
  get 'contact_us', to: 'dashboard#contact_us', as: 'contact_us'
  get 'message_sent', to: 'dashboard#message_sent', as: 'message_sent'
  post 'send_message', to: 'dashboard#send_message', as: 'send_message'

  devise_scope :user do
    get '/passwords/sent'
  end

  get '404', to: 'errors#not_found'
  get '500', to: 'errors#internal_server_error'

  put 'consent-form', to: 'consent#update'
  get 'consent-form', to: 'consent#edit'

  get 'counselor-will-contact', to: 'counselor_contact#show'

  get 'application/logo.png', to: 'application#logo'

  post '/api/v1/duo_limitations', to: 'api#duo_limitations'
  match '/api/*path', to: 'api#not_found', via: :all

  post '/request_otp', to: 'credentials#request_otp'
end
