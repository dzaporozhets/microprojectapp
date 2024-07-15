Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  resources :projects do
    resources :tasks, controller: 'project/tasks'
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
  end

  namespace :admin do
    resources :users, only: [:index]
  end

  get 'admin' => 'admin#index'

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  get "hello" => "hello#welcome"

  # Defines the root path route ("/")
  root "projects#index"
end
