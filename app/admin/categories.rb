ActiveAdmin.register Category do
  
  # Decide what columns to show in the index action. These are typically the fields you want to list out when viewing all categories.
  index do
    selectable_column
    id_column
    column :name
    column :description # Assuming you have a description. If not, remove or replace this line.
    actions
  end

  # Permit parameters for create and update actions. Adjust these based on the actual attributes of your Category model.
  permit_params :name, :description

  # Configuring the form for Create/Update actions
  form do |f|
    f.inputs 'Category Details' do
      f.input :name
      f.input :description
    end
    f.actions
  end

  # Add any filters you'd like to use to narrow down search results within the admin panel
  filter :name
  filter :created_at

  # This section is optional and allows you to customize the display of individual category records.
  show do |category|
    attributes_table do
      row :name
      row :description
      # Add more fields here as necessary.
    end
    active_admin_comments # This adds a section for admin comments if needed.
  end
end
