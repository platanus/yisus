Rails.application.routes.draw do
  mount Sidekiq::Web => '/queue'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  namespace :api, defaults: { format: :json } do
    namespace :internal do
      resources :documents, only: [:create]
    end
  end
  devise_for :users
  root 'time_reports#index'
  resources :time_reports, only: [:index]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
