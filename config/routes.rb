Rails.application.routes.draw do

  root 'homes#index', as:'home'

  get    'user/profile', :to => 'users#show', :as => 'user_show'
  get    'users/login'
  get    'users/logout'
  post   'users/attempt_login'
  get    'users/signup', :to => 'users#new' ,:as => 'users_signup'
  get    'users/edit'
  post   'users/create', :as => 'users_create'
  patch  'users/update'
  delete 'users/destroy'

  resource :product
  get 'products/', to: 'products#index', as: 'products'

  resources :shopping_carts, only: [:index, :create, :destroy, :update]
  post 'shopping_cart/apply-coupon', to:'shopping_carts#get_coupon_value', as: 'coupon'
  get 'shopping_cart/assign_cart_to_user', to:'shopping_carts#assign_cart_to_user', as: 'assign_cart_to_user'
  get 'shopping_carts/checkout', as:'checkout'


end
