Rails.application.routes.draw do

  # Users auth routes
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    confirmations: 'users/confirmations',
    passwords: 'users/passwords',
    registrations:'users/registrations'
  },
  path: '',
  path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    password: 'secret',
    confirmation: 'verification',
    unlock: 'unblock',
    registration: 'registration',
    sign_up: 'new'
  }

  authenticated :user do
    get 'cart' => 'cart#show', as: :cart
    get 'cart/method' => 'cart#new', as: :form
    put 'cart/add/:id', to: 'cart#add', as: :add_to
    put 'cart/remove/:id', to: 'cart#remove', as: :remove_from
    put 'cart/change_payment', to: 'cart#require_change_payment', as: :require_change_payment
    post 'cart/checkout' => 'cart#create', as: :cart_checkout


    get 'packages' => 'packages#index', as: :packages
    patch 'packages/add/:package_id' => 'packages#add_package', as: :add_package
    patch 'packages/remove/:package_id' => 'packages#remove_package', as: :remove_package


    post 'payment' => 'checkout#create', as: :payment
    get 'payment' => 'checkout#new'

    get 'events' => 'events#index', as: :events
    get 'my_events' => 'profile#events', as: :my_events
    get 'my_home' => 'profile#home', as: :my_home


    root 'profile#home', as: :authenticated_user_root
  end

  unauthenticated :user do
    root 'pages#index',  as: :unauthenticated_user_root

    namespace :challenge do
      get 'inscription/new' => 'team#new_inscription', as: :new_team_inscription
      post 'inscription' => 'team#create_inscription', as: :team_inscription

      get 'inscription/:team_id/equipe' => 'member#new_inscription', as: :new_members_inscription
      post 'inscription/:team_id/' => 'member#create_inscription', as: :members_inscription
    end

  end

  # Admin auth routes
  devise_for :admin, controllers: {
    sessions: 'admin/auth/sessions',
    confirmations: 'admin/auth/confirmations',
    passwords: 'admin/auth/passwords'
  },
  path: 'admin',
  path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    password: 'secret',
    confirmation: 'verification',
    unlock: 'unblock',
  }, skip: [:registrations]

  namespace :admin do
    authenticated :admin do
      resources :events do
        resources :schedules, except: [:index, :show]
      end
      resources :event_types, except: [:show]
      resources :packages do
        resources :packages_events_types, only: [:create, :destroy]
      end
      resources :users
      resources :comments
      resources :teams, except: [:new, :create, :edit, :update], scope: "teams"
      post 'teams/:id/confirm_payment' => 'teams#confirm_payment', as: :team_confirm_payment
      patch 'users/:user_id/change_payment' => 'users#set_payment', as: :change_user_payment
      patch 'users/:user_id/remove_from_event/:id' => 'users#remove_from_event', as: :remove_user_from_event
      patch 'users/:user_id/remove_from_all_events' => 'users#remove_from_all_events', as: :remove_user_from_all_events
      resources :admins
    end

    root 'users#index'
  end

end
