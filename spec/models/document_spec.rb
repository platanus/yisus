require 'rails_helper'

RSpec.describe Document, type: :model do
  it 'has a valid factory' do
    expect(build(:document)).to be_valid
  end

  describe 'associations' do
    it { is_expected.to belong_to(:time_report) }
  end

  describe 'validations' do
    subject { build(:document) }

    it { is_expected.to validate_presence_of(:bsale_id) }
    it { is_expected.to validate_presence_of(:url) }
    it { is_expected.to validate_uniqueness_of(:bsale_id) }
  end
end
