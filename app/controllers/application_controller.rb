class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :current_user, :current_shopping_cart

  def current_user
    if session[:user_id]
      @current_user = User.find(session[:user_id])
    end
  end

  def current_shopping_cart
    if session[:user_id]
      @shopping_cart = @current_user.shopping_cart
    elsif session[:shopping_cart]
      @shopping_cart = ShoppingCart.find(session[:shopping_cart])
    else
      @shopping_cart = ShoppingCart.create
      session[:shopping_cart] = @shopping_cart.id
    end
  end


    def confirm_logged_in
      unless session[:user_id]
        flash[:notice] = "Please Login before accessing any Page."
        redirect_to(users_login_path)
      end
    end
end
