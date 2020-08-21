Rails.application.routes.draw do
  root 'recipes#index'
  resources :tags, only: [:show, :index]
  resources :categories, only: [:show, :index]
  resources :recipes do
    collection do
      get :add_ingredient
    end
  end
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
