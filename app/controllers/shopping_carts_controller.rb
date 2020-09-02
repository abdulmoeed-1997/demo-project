class ShoppingCartsController < ApplicationController
  before_action :find_cart_items, :calculate_subtotal

  def index
  end

  def create
    item = @cart_items.find_by(product_id: params[:product_id])

    if item
      if item.update(quantity: params[:quantity])
        redirect_to(shopping_carts_path) and return
      end
    elsif create_new_cart_item(params[:product_id], params[:quantity])
      redirect_to(shopping_carts_path)
    else
      flash[:error] = "Error Adding item to cart."
      redirect_to(product_path)
    end
  end

  def update
    @cart_item = CartItem.find(params[:id])
    
    if @cart_item.update(quantity: params[:quantity])
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
      flash.now[:error] = "Error in removing your cart item."
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
      @shopping_cart.destroy
      @guest_shopping_cart.user = @current_user
      @guest_shopping_cart.save

      @guest_shopping_cart.cart_items.each do |item|
        if item.product.user == @current_user
          item.destroy
        end
      end
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

  def create_new_cart_item(product_id, quantity)
    @cart_item = CartItem.new(shopping_cart_id: @shopping_cart.id, product_id: product_id, quantity: quantity)

    if @cart_item.save
      return true
    else
      return false
    end
  end

end
