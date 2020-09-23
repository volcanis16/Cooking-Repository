Rails.application.routes.draw do
  devise_for :users
  root 'recipes#index'
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

  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
