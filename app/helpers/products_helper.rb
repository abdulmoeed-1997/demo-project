module ProductsHelper

  def product_category_name(id)
    cat = Category.find(id)
    cat.category_type
  end

end
