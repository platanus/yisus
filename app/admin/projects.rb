ActiveAdmin.register Project do
  permit_params :name, :harvest_id, :unit_price, :customer_id

  index do
    id_column
    column :name
    column :harvest_id
    column :unit_price
    column :customer
    actions
  end

  show do
    attributes_table do
      row :name
      row :harvest_id
      row :unit_price
      row :customer
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :harvest_id
      f.input :unit_price
      f.input :customer
    end
    f.actions
  end
end
