# frozen_string_literal: true

Rails.application.routes.draw do
  get 'home', to: 'users/pages#home'
  get 'contact', to: 'users/pages#contact'
  get 'about_app', to: 'users/pages#about_app'
  get 'term', to: 'users/pages#term'
  get 'about_us', to: 'users/pages#about_us'
  get 'support', to: 'users/pages#support'
  get 'mobile_app', to: 'users/pages#mobile_app'

  root 'users/pages#home'

  scope module: 'devise' do
    devise_for :admins, controllers: {
      passwords: 'devise/admins/passwords',
      sessions: 'devise/admins/sessions'
    }
    devise_for :users, controllers: {
      confirmations: 'devise/users/confirmations',
      passwords: 'devise/users/passwords',
      registrations: 'devise/users/registrations',
      sessions: 'devise/users/sessions',
      unlocks: 'devise/users/unlocks'
    }
  end
  devise_scope :user do
    get 'sign_in', to: 'devise/users/sessions#new'
    post 'sign_in', to: 'devise/users/sessions#create'
    delete 'sign_out', to: 'devise/users/sessions#destroy'
    get 'sign_up', to: 'devise/users/registrations#new'
  end

  namespace :admins do
    get 'dashboard', to: 'pages#dashboard'
    resources :podcast_albums
    resources :counselors
    resources :users do
      member do
        patch 'toggle_anonymous', to: 'users#toggle_anonymous'
      end
    end
    resources :rooms do
      member do
        patch 'change_status'
      end
    end
  end

  namespace 'users' do
    resource :user_infos
    resources :podcasts do
      member do
        post 'toggle_bookmark'
        patch'set_duration'
      end
    end
    resources :podcast_albums do
      member do
        post 'toggle_bookmark'
        post 'like'
      end
    end
    resources :confessions do
      member do
        post 'toggle_bookmark'
        post 'like'
      end
    end
    resources :album_homepages, only: [:index, :show]
    resources :confessions, except: %i[edit] do
      member do
        post 'like'
      end
    end
    resources :rooms, only: [:index] do
      member do
        patch 'join_room'
        patch 'out_room'
        get 'room_chat'
      end
    end
  end

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
