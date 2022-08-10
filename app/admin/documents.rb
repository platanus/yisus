ActiveAdmin.register Document do
  permit_params :bsale_id, :url, :time_report_id

  index do
    column :bsale_id
    column :url
    column :time_report
    actions
  end

  show do
    attributes_table do
      row :bsale_id
      row :url
      row :time_report
    end
  end
end
