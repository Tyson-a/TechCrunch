ActiveAdmin.register ContactPage do
  permit_params :title, :content

  form do |f|
    f.inputs 'Contact Page Details' do
      f.input :title
      f.input :content, as: :text
    end
    f.actions
  end

  # Customize the index page, show page, etc., as needed
end
