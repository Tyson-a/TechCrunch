ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :street, :city, :province_id

  index do
    selectable_column
    id_column
    column :email
    column :street
    column :city
    column "Province" do |user|
      user.province.name if user.province
    end
    actions
  end

  filter :email

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :street
      f.input :city
      f.input :province, as: :select, collection: Province.all.map { |province| [province.name, province.id] }
    end
    f.actions
  end

  show do
    attributes_table do
      row :email
      row :street
      row :city
      row :province
      # Add more fields here if needed
    end
  end
end
