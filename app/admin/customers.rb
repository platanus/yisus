ActiveAdmin.register Customer do
  permit_params :name, :harvest_id, :bsale_id

  index do
    id_column
    column :name
    column :harvest_id
    column :bsale_id
    actions
  end

  show do
    attributes_table do
      row :name
      row :harvest_id
      row :bsale_id
      row :updated_at
      row :created_at
    end
  end
end
