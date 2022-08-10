class Document < ApplicationRecord
  belongs_to :time_report

  validates :bsale_id, :url, presence: true
  validates :bsale_id, uniqueness: true
end

# == Schema Information
#
# Table name: documents
#
#  id             :bigint(8)        not null, primary key
#  bsale_id       :integer          not null
#  url            :string           not null
#  time_report_id :bigint(8)        not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_documents_on_bsale_id        (bsale_id) UNIQUE
#  index_documents_on_time_report_id  (time_report_id)
#
# Foreign Keys
#
#  fk_rails_...  (time_report_id => time_reports.id)
#
