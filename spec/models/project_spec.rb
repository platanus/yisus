require 'rails_helper'

RSpec.describe Project, type: :model do
  it 'has a valid factory' do
    expect(build(:project)).to be_valid
  end

  describe 'associations' do
    it { is_expected.to belong_to(:customer) }
    it { is_expected.to have_many(:time_reports)}
  end

  describe 'validations' do
    subject { build(:project) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:harvest_id) }
    it { is_expected.to validate_presence_of(:unit_price) }
    it { is_expected.to validate_uniqueness_of(:harvest_id) }
  end
end
