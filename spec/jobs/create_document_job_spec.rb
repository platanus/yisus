require 'rails_helper'

RSpec.describe CreateDocumentJob, type: :job do
  describe '#perform_now' do
    let(:time_report) { create(:time_report) }
    let(:time_report_id) { time_report.id }
    let(:bsale_document) { { id: '1', urlPdfOriginal: 'url' } }
    let(:post_document) { instance_double(ClientResponse, success?: true, body: bsale_document) }
    let(:bsale_client) { instance_double(BsaleClient, post_document: post_document) }

    def perform
      described_class.perform_now(time_report_id)
    end

    before { allow(BsaleClient).to receive(:new).and_return(bsale_client) }

    it 'creates bsale client' do
      perform
      expect(BsaleClient).to have_received(:new)
    end

    it 'calls #post_document method of bsale client' do
      perform
      expect(bsale_client).to have_received(:post_document)
    end

    context 'when time report is found' do
      let(:time_report_id) { time_report.id }

      context 'when bsale client response is a success' do
        it { expect { perform }.to change { Document.count }.by(1) }
      end

      context 'when bsale client response is not a success' do
        let(:post_document) { instance_double(ClientResponse, success?: false, body: {}) }

        it { expect { perform }.to raise_error('Bsale API error') }
      end
    end

    context 'when time report is not found' do
      let(:time_report_id) { 0 }

      it { expect { perform }.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end
end
