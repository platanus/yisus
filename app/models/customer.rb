class Customer < ApplicationRecord
  has_many :projects, dependent: :destroy

  validates :name, :harvest_id, :bsale_id, presence: true
  validates :harvest_id, :bsale_id, uniqueness: true
end

# == Schema Information
#
# Table name: customers
#
#  id         :bigint(8)        not null, primary key
#  name       :string           not null
#  harvest_id :integer          not null
#  bsale_id   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_customers_on_bsale_id    (bsale_id) UNIQUE
#  index_customers_on_harvest_id  (harvest_id) UNIQUE
#
