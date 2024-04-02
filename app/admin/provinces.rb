ActiveAdmin.register Province do
  permit_params :name, :pst, :gst, :hst # Add other fields as necessary

  index do
    selectable_column
    id_column
    column :name
    column :pst
    column :gst
    column :hst
    actions
  end

  filter :name

  form do |f|
    f.inputs do
      f.input :name
      f.input :pst, label: 'PST Rate (%)'
      f.input :gst, label: 'GST Rate (%)'
      f.input :hst, label: 'HST Rate (%)'
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :pst
      row :gst
      row :hst
    end
  end
end
