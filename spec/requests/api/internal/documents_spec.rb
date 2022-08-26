require 'rails_helper'

RSpec.describe 'Api::Internal::DocumentsControllers', type: :request do
  let(:user) { create(:user) }

  describe 'POST /create' do
    let(:time_report) { create(:time_report) }
    let(:document) { create(:document, time_report: time_report) }
    let(:params) do
      {
        document: {
          time_report_id: time_report.id
        }
      }
    end

    let(:attributes) do
      JSON.parse(response.body)['document'].symbolize_keys
    end

    def perform
      post '/api/internal/documents', params: params
    end

    before do
      allow(CreateDocumentJob).to receive(:perform_now).and_return({ document: document })
      sign_in user
      perform
    end

    it { expect(CreateDocumentJob).to have_received(:perform_now).with(time_report.id.to_s) }
    it { expect(attributes).to include(params[:document]) }
    it { expect(response.status).to eq(201) }

    context 'with invalid attributes' do
      let(:params) do
        {
          document: nil
        }
      end

      it { expect(response.status).to eq(500) }
    end
  end
end
