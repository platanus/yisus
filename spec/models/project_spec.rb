require 'rails_helper'

RSpec.describe Project, type: :model do
  it 'has a valid factory' do
    expect(build(:project)).to be_valid
  end

  describe 'associations' do
    it { is_expected.to belong_to(:customer) }
  end

  describe 'validations' do
    subject { build(:project) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:harvest_id) }
    it { is_expected.to validate_presence_of(:unit_price) }
  end
end
