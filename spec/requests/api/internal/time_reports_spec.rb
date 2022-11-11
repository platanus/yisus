require 'rails_helper'

RSpec.describe 'Api::Internal::TimeReportsControllers', type: :request do
  let(:user) { create(:user) }

  describe 'GET /index' do
    let(:date1) { Date.new(2022, 8, 1) }
    let!(:time_report1) do
      create(:time_report, from: date1.beginning_of_month, to: date1.end_of_month)
    end
    let(:date2) { Date.new(2022, 9, 1) }
    let!(:time_report2) do
      create(:time_report, from: date2.beginning_of_month, to: date2.end_of_month)
    end
    let(:params) { { date: '2022-09-15' } }
    let(:collection) { JSON.parse(response.body)['time_reports'] }

    def perform
      get '/api/internal/time_reports', params: params
    end

    before do
      sign_in user
      perform
    end

    it { expect(collection.count).to eq(1) }
    it { expect(response.status).to eq(200) }
  end

  describe 'POST /create' do
    def perform
      post '/api/internal/time_reports', params: { date: '2022-09-15' }
    end

    before do
      allow(FetchHarvestDataJob).to receive(:perform_now)
      sign_in user
      perform
    end

    it 'calls FetchHarvestTimeReportsJob' do
      expect(FetchHarvestDataJob).to have_received(:perform_now)
    end
  end
end
