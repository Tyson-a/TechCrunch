class User < ApplicationRecord
  belongs_to :province, optional: true
  validates :password, presence: true, confirmation: true, if: -> { new_record? || !password.nil? }
  has_many :orders
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

  def update_province
    current_user.update(province_params)
    redirect_to invoice_path
  end

  private

  def province_params
    params.require(:user).permit(:province_id)
  end

end
