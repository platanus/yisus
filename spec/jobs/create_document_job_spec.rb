require 'rails_helper'

RSpec.describe CreateDocumentJob, type: :job do
  let(:time_report) { create(:time_report) }

  describe '#perform_now' do
    let(:bsale_document) { { 'id' => '1', 'urlPdfOriginal' => 'url' } }
    let(:bsale_client) { instance_double(BsaleClient, post_document: bsale_document) }

    def perform
      described_class.perform_now(time_report_id)
    end

    before { allow(BsaleClient).to receive(:new).and_return(bsale_client) }

    context 'when time report is found' do
      let(:time_report_id) { time_report.id }

      it 'creates bsale client' do
        perform
        expect(BsaleClient).to have_received(:new)
      end

      it 'calls #post_document method of bsale client' do
        perform
        expect(bsale_client).to have_received(:post_document)
      end

      context 'when bsale client response is a success' do
        it { expect { perform }.to change { Document.count }.by(1) }
      end

      context 'when bsale client response is not a success' do
        let(:bsale_document) { {} }

        it { expect { perform }.to raise_error(ActiveRecord::RecordInvalid) }
      end
    end

    context 'when time report is not found' do
      let(:time_report_id) { 0 }

      it { expect { perform }.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end
end
