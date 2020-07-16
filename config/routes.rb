Rails.application.routes.draw do

  get    'user/profile', :to => 'users#show', :as => 'user_show'
  get    'users/login'
  get    'users/logout'
  post   'users/attempt_login'
  get    'users/signup', :to => 'users#new' ,:as => 'users_signup'
  get    'users/edit'
  post   'users/create', :as => 'users_create'
  patch  'users/update'
  delete 'users/destroy'


end
