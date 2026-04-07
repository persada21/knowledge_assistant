require "sidekiq/web"

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"

  root "pages#home"

  resources :documents, only: [:index, :new, :create, :show]
  resources :questions, only: [:new, :create, :show]

  namespace :api do
    namespace :v1 do
      resources :questions, only: [:create]
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
