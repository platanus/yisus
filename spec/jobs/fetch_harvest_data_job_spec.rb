require 'rails_helper'

RSpec.describe FetchHarvestDataJob, type: :job do
  let(:date_range) { { from: Date.new(2022, 1, 1), to: Date.new(2022, 1, 31) } }

  describe '#perform_now' do
    before do
      allow(FetchHarvestProjectsJob).to receive(:perform_now)
      allow(FetchHarvestTimeReportsJob).to receive(:perform_now)
      described_class.perform_now(date_range)
    end

    it 'calls FetchHarvestProjectsJob' do
      expect(FetchHarvestProjectsJob).to have_received(:perform_now)
    end

    it 'calls FetchHarvestTimeReportsJob' do
      expect(FetchHarvestTimeReportsJob).to have_received(:perform_now).with(date_range)
    end
  end
end
