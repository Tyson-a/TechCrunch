# app/models/cart.rb
class Cart < ApplicationRecord
  belongs_to :User, optional: true
  has_many :cart_items, dependent: :destroy
end

# app/models/cart_item.rb
class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product
  validates :quantity, presence: true, numericality: { greater_than: 0 }
end

# app/models/user.rb
class User < ApplicationRecord
  has_one :cart
end

# app/models/product.rb
class Product < ApplicationRecord
  has_many :cart_items
end
