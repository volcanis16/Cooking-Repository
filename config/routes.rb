Rails.application.routes.draw do
  root 'recipes#index'
  get '/search' => 'search#search', :as => 'search'
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
