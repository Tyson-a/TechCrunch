class Province < ApplicationRecord
  # Model relationships and validations can be added here
  has_many :users
  def self.ransackable_attributes(auth_object = nil)
    %w[name pst gst hst] # List only the attributes you want to be searchable
  end

end
