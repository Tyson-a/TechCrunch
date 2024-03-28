class Province < ApplicationRecord
  # Model relationships and validations can be added here
  has_many :users
end
