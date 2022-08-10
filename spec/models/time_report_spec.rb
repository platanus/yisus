require 'rails_helper'

RSpec.describe TimeReport, type: :model do
  it 'has a valid factory' do
    expect(build(:time_report)).to be_valid
  end

  describe 'associations' do
    it { is_expected.to belong_to(:project) }
  end

  describe 'validations' do
    subject { build(:time_report) }

    it { is_expected.to validate_presence_of(:from) }
    it { is_expected.to validate_presence_of(:to) }
    it { is_expected.to validate_presence_of(:billable_hours) }
  end
end
