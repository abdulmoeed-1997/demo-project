class Coupon < ApplicationRecord

  #validations
  validates :key, presence: true

  validates :value,
            numericality: { greater_than_or_equal_to: 0,
                            less_than_or_equal_to: 100,
                            message: 'must be greater than 0 and less than 100' }
end
