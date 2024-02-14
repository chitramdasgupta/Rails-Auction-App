# frozen_string_literal: true

Rails.application.routes.draw do
  get 'bids/create'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  root 'home#index'
  resources :users, only: %i[new create]
  resources :products, only: %i[index show] do
    resources :bids, only: [:create]
    patch :select_bid, on: :member
  end
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :posts, only: [:index]
end
