class CheckoutController < ApplicationController

  before_action :confirm_logged_in

  def create
    cart_items =  @shopping_cart.cart_items
    user = @shopping_cart.user
    items = []
    cart_items.each { |item| items << {name: item.product.name , amount: item.product.price*100, quantity: item.quantity, currency: 'usd'} }

    @session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      customer_email: user.email,
      line_items: items,
      success_url: checkout_success_url + '?session_id={CHECKOUT_SESSION_ID}',
      cancel_url: shopping_carts_url
    )
  end

  def success
    #@session = Stripe::Checkout::Session.retrieve(params[:session_id])
    #@payment_intent = Stripe::PaymentIntent.retrieve(@session.payment_intent)
    flash[:notice]="Your order has been placed. Thanks for shopping with us."
    redirect_to(user_show_path(@current_user))
  end


end
