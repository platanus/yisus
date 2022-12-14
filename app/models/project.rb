class Project < ApplicationRecord
  belongs_to :customer
  has_many :time_reports, dependent: :destroy

  validates :name, :harvest_id, :unit_price, presence: true
  validates :harvest_id, uniqueness: true
end

# == Schema Information
#
# Table name: projects
#
#  id          :bigint(8)        not null, primary key
#  name        :string           not null
#  harvest_id  :integer          not null
#  unit_price  :float            not null
#  customer_id :bigint(8)        not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_projects_on_customer_id  (customer_id)
#  index_projects_on_harvest_id   (harvest_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (customer_id => customers.id)
#
