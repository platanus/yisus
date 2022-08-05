require 'rails_helper'

RSpec.describe Customer, type: :model do
  it 'has a valid factory' do
    expect(build(:customer)).to be_valid
  end

  describe 'associations' do
    it { is_expected.to have_many(:projects) }
  end

  describe 'validations' do
    subject { build(:customer) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:harvest_id) }
    it { is_expected.to validate_presence_of(:bsale_id) }
  end
end
