ActiveAdmin.register TimeReport do
  permit_params :from, :to, :billable_hours, :project_id

  index do
    column :from
    column :to
    column :billable_hours
    column :project
    actions
  end

  show do
    attributes_table do
      row :from
      row :to
      row :billable_hours
      row :project
    end
  end
end
