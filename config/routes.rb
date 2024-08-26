Rails.application.routes.draw do
  devise_for :users, controllers: {
    passwords: 'users/passwords',
    confirmations: 'users/confirmations',
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  resources :projects do
    resources :tasks, controller: 'project/tasks' do
      member do
        get :details
        get :expand
        patch :toggle_done
        patch :toggle_star
      end

      resources :comments, controller: 'project/comments', only: [:create, :destroy]
    end

    resources :links, controller: 'project/links', only: [:index, :new, :create, :show, :destroy]

    resources :files, controller: 'project/files', only: [:index, :new, :create] do
      collection do
        get :download
        delete :destroy, as: 'delete'
      end
    end

    resources :users, only: [:destroy], controller: 'project/users' do
      collection do
        get 'invite', to: 'project/users#invite'
        post 'add_member', to: 'project/users#add_member'
      end
    end

    resource :schedule, only: :show, controller: 'project/schedule' do
      member do
        post 'saturate'
      end
    end

    resource :activity, only: :show, controller: 'project/activity'

    resource :import, only: [:new, :create, :show], controller: 'project/import'
    resource :export, only: [:new, :create], controller: 'project/export'
  end

  namespace :admin do
    resources :users, only: [:index, :show]
  end

  get 'admin' => 'admin#index'

  namespace :users do
    resource :settings, only: [:show, :update]
  end

  resource :schedule, only: :show, controller: 'schedule'
  resources :tasks, only: :index, controller: 'tasks'

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  get "hello" => "hello#welcome"

  # Defines the root path route ("/")
  root "projects#index"
end
