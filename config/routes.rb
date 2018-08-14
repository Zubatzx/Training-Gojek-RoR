Rails.application.routes.draw do
  # get 'store/index'
  root 'store#index',as: 'store_index'
  resources :foods
  get 'home/hello'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
