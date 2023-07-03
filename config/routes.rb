require 'sidekiq/web'
Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'users/registrations' }
  resources :service_types
  resources :parcels
  resources :addresses
  resources :users_admin, :controller => 'users'
  resources :reports do 
    member do
      get :download
    end
  end
  #root to: 'parcels#index'
  root to: 'home#index'
  get '/search', to: 'search#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  authenticate :user do
    mount Sidekiq::Web => "/sidekiq"
  end
end
