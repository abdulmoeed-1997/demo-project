class CheckoutController < ApplicationController
  before_action :confirm_logged_in, :get_cart_items
  before_action :update_cart_before_checkout, only: [:create]
  before_action :update_cart_after_checkout,  only: [:success] 

  def create
    user = @shopping_cart.user
    items = []
    @cart_items.each { |item| items << {name: item.product.name , amount: item.product.price*100, quantity: item.quantity, currency: 'usd'} }
    @session = strip_session(user, items)
  end

  def success
    @cart_items.destroy_all
    session[:shopping_cart] = nil
    flash[:notice]="Your order has been placed. Thanks for shopping with us."
    redirect_to(user_path)
  end

  def get_cart_items
    @cart_items =  @shopping_cart.cart_items
  end

  private

  def strip_session(user, items)
    return Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      customer_email: user.email,
      line_items: items,
      success_url: success_checkout_index_url + '?session_id={CHECKOUT_SESSION_ID}',
      cancel_url: shopping_carts_url
    )
  end

  def update_cart_before_checkout
    @cart_items.each do |item|
      if item.quantity > item.product.quantity
        item.quantity = item.product.quantity
      end
    end
  end

  def update_cart_after_checkout
    @cart_items.each do |item|
      product = item.product
      qty = product.quantity - item.quantity
      product.update(quantity: qty)
    end
  end

end