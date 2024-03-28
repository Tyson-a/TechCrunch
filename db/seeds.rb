# require 'csv'

# # Define your CSV file paths with associated categories
# csv_file_paths = {
#   'CPUs' => Rails.root.join('lib', 'seeds', 'cpu.csv'),
#   'Memory' => Rails.root.join('lib', 'seeds', 'memory.csv'),
#   'Monitors' => Rails.root.join('lib', 'seeds', 'monitor.csv'),
#   'Motherboards' => Rails.root.join('lib', 'seeds', 'motherboard.csv'),
#   'Power Supplies' => Rails.root.join('lib', 'seeds', 'power-supply.csv'), # Fixed typo
#   'GPUs' => Rails.root.join('lib', 'seeds', 'video-card.csv'),
# }

# csv_file_paths.each do |category_name, file_path|
#   category = Category.find_or_create_by(name: category_name)

#   CSV.foreach(file_path, headers: true) do |row|
#     Product.create(
#       name: row['name'],
#       description: row['description'],
#       price: row['price'],
#       category: category # Here, category is determined by the CSV file
#     )
#   end
# end

# AdminUser.find_or_create_by!(email: 'admin@example.com') do |admin|
#   admin.password = 'password'
#   admin.password_confirmation = 'password'
# end

provinces = [
  { name: "Alberta", gst: 5, pst: 0, hst: 0 },
  { name: "British Columbia", gst: 5, pst: 7, hst: 0 },
  { name: "Manitoba", gst: 5, pst: 7, hst: 0 },
  { name: "Newfoundland and Labrador", gst: 0, pst: 0, hst: 15 },
  { name: "Northwest Territories", gst: 5, pst: 0, hst: 0 },
  { name: "Nova Scotia", gst: 0, pst: 0, hst: 15 },
  { name: "Nunavut", gst: 5, pst: 0, hst: 0 },
  { name: "Ontario", gst: 0, pst: 0, hst: 13 },
  { name: "Prince Edward Island", gst: 0, pst: 0, hst: 15 },
  { name: "Quebec", gst: 5, pst: 9.975, hst: 0 },
  { name: "Yukon", gst: 5, pst: 0, hst: 0 },
  { name: "Saskatchewan", gst: 5, pst: 6, hst: 0 },


]

provinces.each do |province|
  Province.find_or_create_by(name: province[:name]) do |p|
    p.gst = province[:gst]
    p.pst = province[:pst]
    p.hst = province[:hst]
  end
end
