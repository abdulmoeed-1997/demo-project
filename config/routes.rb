Rails.application.routes.draw do
  root 'homes#index', as: :home

  resource :user do
    collection do
        get  :login
        get  :logout
        get  :products
        post :attempt_login
    end
  end

  resources :comments, only: [:create, :edit, :destroy, :update]
  
  resources :products do
    member do
      delete :delete_image_attachment
    end
    collection do
      get :search
      get :category
    end
  end

  resources :shopping_carts, only: [:index, :create, :destroy, :update] do
    collection do
      post :get_coupon_value
      get  :assign_cart_to_user
    end
  end

  resources :checkout, only: [:create] do
    collection do
      get :success
    end
  end

end
