ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :address, :city, :province_id, :other, :attributes

  index do
    selectable_column
    id_column
    column :email
    column :address
    column :city
    column "Province" do |user|
      user.province.name if user.province
    end
    actions
  end

  filter :email

  controller do
    def update
      # If password fields are blank, remove them from params to avoid changing the password
      if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
      end

      super
    end
  end

  form do |f|
    f.inputs do
      f.input :email
      if f.object.new_record? || params[:action] == 'edit'
        f.input :password, hint: "Leave blank if you don't want to change it"
        f.input :password_confirmation, hint: "Leave blank if you don't want to change it"
      end
      f.input :address
      f.input :city
      f.input :province, as: :select, collection: Province.all.map { |province| [province.name, province.id] }
    end
    f.actions
  end
  show do
    attributes_table do
      row :email
      row :address
      row :city
      row :province
    end
  end
end
