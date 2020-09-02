class ProductsController < ApplicationController
  before_action :confirm_logged_in, except: [:index, :show, :search, :category]
  before_action :find_categories,   except: [:destroy, :delete_image_attachment, :show]
  before_action :find_product,      only:   [:show, :update, :edit, :destroy, :delete_image_attachment]
  before_action :authorize,         only:   [:update, :edit, :delete]

  def index
    @products = Product.all
  end

  def search
    if params[:search].present?
      @products = Product.search(params[:search])
    else
      flash.now[:error] = "Sorry, No product Found."
    end
    render('index')
  end

  def category
    if params[:category_id].present?
      @products = Product.where(category_id: params[:category_id])
    else
      flash.now[:error] = "Sorry, No product Found."
    end
    render('index')
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    @product.images.attach(params[:product][:images])
    @product.user = @current_user
    
    if @product.save
      flash[:notice] = "Your Product is Successfully Added."
      redirect_to(user_path)
    else
      render('new')
    end
  end

  def show
    @comments = @product.comments.last(5).reverse
  end

  def edit
  end

  def update
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
    @product.destroy
    flash[:notice] = "Your Product has been Successfully deleted."
    redirect_to(user_path)
  end

  def delete_image_attachment
    attachment = @product.images.find(params[:image_id])
    attachment.purge_later
    #redirect_back(fallback_location: products_path)
  end

  private
  
  def product_params
    params.require(:product).permit(
      :name,
      :description,
      :quantity,
      :category_id,
      :price
  )
  end

  def find_categories
    @categories = Category.all
  end

  def find_product
    @product = Product.find(params[:id])
  end

  def authorize
    if @current_user != @product.user
      redirect_to(home_path) and return
    end
  end

end
