class Product < ApplicationRecord
  belongs_to          :user
  belongs_to          :category
  has_many_attached   :images
  has_many            :cart_items,  dependent: :destroy 
  has_many            :comments,    dependent: :destroy 

  after_save :create_serial_number

  attr_accessor :delete_images

  searchkick word_middle: [:name, :description]

  def search_data
    {
      name: name,
      description: description,
      price: price,
      serial_no: serial_no
    }
  end

  scope :sorted_by_date,  ->  { order("created_at DESC") }
  scope :sorted_by_price, ->  { order("price DESC") }

  validates :name,    presence: true,
                      length: {maximum: 50}

  validates :price,   presence: true,
                      numericality: { only_integer: true,
                                      greater_than_or_equal_to: 0,
                                      message: 'must be greater than 0' }

  validates :quantity, presence: true,
                       numericality: { only_integer: true,
                                       greater_than_or_equal_to: 0,
                                       message: 'must be greater than 0' }

  validates :description, presence: true
  validates :serial_no,   uniqueness: true

  private

  def create_serial_number
    update_column(:serial_no, self.serial_no = "PSN-0#{id}")
  end
end
