class TimeReportSerializer < ActiveModel::Serializer
  attributes(
    :id,
    :from,
    :to,
    :billable_hours
  )

  belongs_to :project
  has_one :document
end
