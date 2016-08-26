Rails.application.routes.draw do

  # Users auth routes
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    confirmations: 'users/confirmations',
    passwords: 'users/passwords',
    registrations:'users/registrations'
  },
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
    get 'dashboard' => 'profiles#index', as: :user_dashboard

  	resource :cart do
      put 'add/:id', to: 'carts#add', as: :add_to
      put 'remove/:id', to: 'carts#remove', as: :remove_from
      get 'formadepagamento' => 'carts#new', as: :form
    end




    post 'payment' => 'checkout#create', as: :payment
    get 'payment' => 'checkout#new'

    get 'programacao' => 'profiles#week', as: :events
    get 'minhasemana' => 'profiles#week_user', as: :my_events


    root 'profiles#index', as: :authenticated_user_root
  end

  unauthenticated :user do
    root 'pages#index',  as: :unauthenticated_user_root

    namespace :challenge do
      get 'inscricao/nova' => 'team#new_inscription', as: :new_team_inscription
      post 'inscricao' => 'team#create_inscription', as: :team_inscription

      get 'inscricao/:team_id/equipe' => 'member#new_inscription', as: :new_members_inscription
      post 'inscricao/:team_id/' => 'member#create_inscription', as: :members_inscription
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
      resources :events
      resources :packages 
      resources :users do
        patch 'change_payment' => 'users#set_payment', as: :change_user_payment
      end
      resources :admins
    end

    root 'events#index'
  end

end
