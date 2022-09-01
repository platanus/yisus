ActiveAdmin.register TimeReport do
  permit_params :from, :to, :billable_hours, :project_id

  collection_action :fetch, method: :get do
    FetchHarvestTimeReportsJob.perform_now(Date.current)
    redirect_to collection_path, notice: "¡Reportes obtenidos exitosamente!"
  end

  action_item :fetch, only: :index do
    link_to 'Obtener reportes del mes', fetch_admin_time_reports_path
  end

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
