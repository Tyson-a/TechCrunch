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

