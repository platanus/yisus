class TimeReport < ApplicationRecord
  belongs_to :project
  has_one :document, dependent: :nullify

  validates :from, :to, :billable_hours, presence: true
end

# == Schema Information
#
# Table name: time_reports
#
#  id             :bigint(8)        not null, primary key
#  from           :date             not null
#  to             :date             not null
#  billable_hours :float            not null
#  project_id     :bigint(8)        not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_time_reports_on_project_id  (project_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#
