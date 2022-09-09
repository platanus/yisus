require 'rails_helper'

RSpec.describe CreateDocumentJob, type: :job do
  describe '#perform_now' do
    let(:time_report) { create(:time_report) }
    let(:time_report_id) { time_report.id }
    let(:post_document) do
      instance_double(
        ClientResponse,
        success?: true,
        body: { 'id' => '1', 'urlPdfOriginal' => 'url' }
      )
    end
    let(:bsale_client) { instance_double(BsaleClient, post_document: post_document) }
    let(:cmf_response) do
      instance_double(
        ClientResponse,
        success?: true,
        body: { 'UFs' => [{ 'Valor' => '30.000,07' }] }
      )
    end
    let(:cmf_client) { instance_double(CmfClient, get_uf: cmf_response) }

    def perform
      described_class.perform_now(time_report_id)
    end

    before do
      allow(BsaleClient).to receive(:new).and_return(bsale_client)
      allow(CmfClient).to receive(:new).and_return(cmf_client)
    end

    it 'creates cmf client' do
      perform
      expect(CmfClient).to have_received(:new)
    end

    it 'calls get_uf method of cmf client' do
      perform
      expect(cmf_client).to have_received(:get_uf).with(Date.current)
    end

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

      it { expect { perform }.to change { Document.count }.by(1) }
    end

    context 'when time report is not found' do
      let(:time_report_id) { 0 }

      it { expect { perform }.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end
end
