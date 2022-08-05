ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :role_ids, :carrier_id

  index do
    id_column
    column :email
    column :roles
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :email
      row :roles
      row :created_at
      row :updated_at
      row :carrier if user.has_role?(:carrier)
    end
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :roles, as: :radio
      f.input :carrier
    end
    f.actions
  end
end
