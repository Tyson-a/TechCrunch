class Province < ApplicationRecord
  # Model relationships and validations can be added here
  has_many :users
  validates :name, presence: true, uniqueness: true
  validates :pst, :gst, :hst, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100, allow_nil: true }
  def self.ransackable_attributes(auth_object = nil)
    %w[name pst gst hst] # List only the attributes you want to be searchable
  end

end
