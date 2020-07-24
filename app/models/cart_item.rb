class CartItem < ApplicationRecord
  belongs_to :product
  belongs_to :shopping_cart

  #validations
  validates :quantity, :presence => true,
            numericality: { only_integer: true,
                            greater_than_or_equal_to: 0,
                            message: 'must be greater than 0' }

end
