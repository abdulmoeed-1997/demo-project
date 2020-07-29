class ShoppingCartsController < ApplicationController

  before_action :find_cart_items, :calculate_subtotal

  def index
  end

  def create
    @cart_item = CartItem.new
    @cart_item.shopping_cart_id = @shopping_cart.id
    @cart_item.product_id = params[:product_id].to_i
    @cart_item.quantity = params[:quantity].to_i
    if @cart_item.save
      redirect_to(shopping_carts_path)
    else
      flash[:error] = "Error Adding item to cart."
      redirect_to(product_path)
    end
  end

  def update
    @cart_item = CartItem.find(params[:id])
    quantity = params[:quantity].to_i
    if @cart_item.update(quantity: quantity)
      redirect_to(shopping_carts_path)
    else
      flash.now[:error] = "Error in updating your cart item."
      render('index')
    end
  end

  def destroy
    if CartItem.find(params[:id]).destroy
      redirect_to(shopping_carts_path)
    else
      flash.now[:error] = "Error in updating your cart item."
      render('index')
    end
  end

  def get_coupon_value
    @coupon = Coupon.where(key: params[:key]).first
    if @coupon != nil
      @value = @coupon.value.to_f
      @discount = calculate_discount(@subtotal.to_f, @value.to_f)
      flash[:notice] = "show discount msg"
    else
      flash[:notice] = "show some error"
    end

  end


  def assign_cart_to_user
    if session[:shopping_cart]
      @guest_shopping_cart = ShoppingCart.find(session[:shopping_cart])
      @shopping_cart.destroy  #destroy user's previous shopping cart
      @guest_shopping_cart.user = @current_user
      @guest_shopping_cart.save
      session[:shopping_cart] = nil
      redirect_to(shopping_carts_path)
    end
  end


  private
  def find_cart_items
    @cart_items = @shopping_cart.cart_items
  end

  def calculate_discount(total, value)
    discount = total * (value/100)
  end

  def calculate_subtotal
    cart_items = find_cart_items
    @subtotal = 0
    cart_items.each do |item|
      @subtotal += item.product.price * item.quantity
    end

  end

end
