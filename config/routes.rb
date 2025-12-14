# frozen_string_literal: true

Rails.application.routes.draw do
  # Root path
  root 'emails#index'

  # Email routes
  resources :emails, only: %i[index show]

  # Reporting routes
  resources :reports, only: [:create]

  # Admin routes
  namespace :admin do
    get 'dashboard', to: 'dashboard#index'
  end

  # Health check
  get 'up' => 'rails/health#show', as: :rails_health_check
end
