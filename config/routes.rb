# frozen_string_literal: true

Rails.application.routes.draw do
  require 'sidekiq/web'

  Rails.application.routes.draw do
    authenticate :event_manager do
      mount Sidekiq::Web => '/sidekiq'
    end
  end

  apipie

  devise_for :users

  devise_for :event_manager, controllers: { registrations: 'event_managers/registrations',
                                            sessions: 'event_managers/sessions' }

  devise_for :attendee, controllers: { registrations: 'attendees/registrations',
                                       sessions: 'attendees/sessions' }

  namespace :api do
    namespace :v1 do
      resources :users, only: %i[index create show update destroy]
    end
  end

  namespace :attendees do
    resources :avatars, only: %i[new update destroy]
    resources :events, only: %i[index show] do
      collection do
        get :past_events
        get :upcoming_events
      end
      resources :rsvps, only: %i[create]
    end
  end

  namespace :event_managers do
    resources :avatars, only: %i[new update destroy]
    resources :events, only: %i[new create index show edit destroy update] do
      resources :rsvps, only: %i[index update]
      collection do
        post :download
      end
    end
  end

  get '/dashboard' => 'home#dashboard'
  get '/homepage' => 'home#homepage'
  root to: redirect('/homepage')
end
