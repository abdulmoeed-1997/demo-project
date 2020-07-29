class CommentsController < ApplicationController

  before_action :confirm_logged_in

  def create
    product = Product.find(params[:product_id])
    content = params[:comment]
    comment = Comment.create(user: @current_user, product: product, content: content)
    @comments = product.comments.last(5).reverse
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    comment = Comment.find(params[:id])
    product = comment.product
    if comment.update(content: params[:comment][:content])
      @comments = product.comments.last(5).reverse
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    product = comment.product
    comment.destroy
    @comments = product.comments.last(5).reverse
  end


end
