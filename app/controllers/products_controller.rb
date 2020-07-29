class ProductsController < ApplicationController

  before_action  :find_categories, :only=> [:new, :edit, :create, :update, :index]
  before_action :confirm_logged_in, :except => [:index, :show]

  def index
    if params[:category_id].present?
      @products = Product.where(category_id: params[:category_id])
    elsif params[:search].present?
      @products = Product.search(params[:search])
    elsif params[:user_id].present?
      user = User.find(params[:user_id])
      @products = user.products
    else
      @products = Product.all
    end
  end

  def new
    #show form for adding a new product
    @product = Product.new
  end

  def create
    #it create a new product for a specific user
    @product = Product.new(product_params)
    @product.images.attach(params[:product][:images])
    @user = User.find(params[:format])
    @product.user = @user
    if @product.save
      flash[:notice] = "Your Product is Successfully Added."
      redirect_to(user_show_path(@user))
    else
      render('new')
    end
  end

  def show
    @product = Product.find(params[:format])
    @comments = @product.comments.last(5).reverse
  end

  def edit
    #show form for editing a product
    @product = Product.find(params[:format])
    if @current_user != @product.user
      redirect_to(home_path) and return
    end
  end

  def update
    #it accepts the new attributes of a product and edit its attributes
    @product = Product.find(params[:format])
    if @current_user != @product.user
      redirect_to(home_path) and return
    end
    #delete previous images before updating new ones.
    if @product.update_attributes(product_params)
      if params[:product][:images].present?
       @product.images.attach(params[:product][:images])
     end
      flash[:notice] = "Your Product has been Successfully updated."
      redirect_to(product_path(@product))
    else
      render('edit')

    end
  end

  def destroy
    product = Product.find(params[:format])
    if @current_user != @product.user
      redirect_to(home_path) and return
    end
    product.destroy
    flash[:notice] = "Your Product has been Successfully deleted."
    redirect_to(user_show_path(@current_user))
  end

  private
  def product_params
    params.require(:product).permit(
      :name,
      :description,
      :quantity,
      :category_id,
      :price,
  )
  end

  def find_categories
    @categories = Category.all
  end
end
