Rails.application.routes.draw do

  root 'object_models#index'
  
  resources :items, only: [:index, :show]
  resources :object_models, only: [:index, :show]
  
end
