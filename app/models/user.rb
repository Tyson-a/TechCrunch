class User < ApplicationRecord
  belongs_to :province, optional: true
  has_one :cart
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def self.ransackable_attributes(auth_object = nil)
          %w[id email city province created_at]
  end

  def create_cart
    Cart.create(user_id: self.id)
  end

end
