class User < ApplicationRecord

  has_secure_password
  has_one_attached :avatar


  def name
    "#{first_name} #{last_name}"
  end

  attr_accessor :delete_avatar

  #validation
  EMAIL_REGEX = /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}\Z/i
  validates :first_name, :presence => true,
                       :length => {:maximum => 25}

 validates :last_name, :presence => true,
                      :length => {:maximum => 25}

 validates :username,  :presence => true,
                      :length =>{:within => 8..25},
                      :uniqueness => true

 validates :email, :presence => true,
                   :length => {:maximum => 100},
                   :format => {:with => EMAIL_REGEX},
                   :uniqueness => true

end
