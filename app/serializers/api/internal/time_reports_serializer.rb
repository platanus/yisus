class Api::Internal::TimeReportsSerializer < ActiveModel::Serializer
  type :time_reports

  attributes(
    :id,
    :from,
    :to,
    :billable_hours,
    :project_id,
    :created_at,
    :updated_at
  )

  belongs_to :project
  has_one :document
end
