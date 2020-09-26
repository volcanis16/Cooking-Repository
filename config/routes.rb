Rails.application.routes.draw do
  devise_for :users, controllers: {registrations: 'users/registrations', sessions: 'users/sessions'}
  authenticated :user do
    root to: 'recipes#index', as: :authenticated_root
  end
  root to: redirect('/users/sign_in')
  
  devise_scope :user do
    get '/users/index' => 'users/sessions#index', :as => 'users_index'
  end

  get '/search' => 'search#search', :as => 'search'
  get "/check_tags" => 'recipes#check_tags', :as => 'check_tags'

  resources :options, only: [:show, :edit, :update]
  resources :tags, only: [:show, :index]
  resources :groups
  resources :categories, only: [:show, :index]

  resources :recipes do
    collection do
      get :add_ingredient
    end
  end



  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
