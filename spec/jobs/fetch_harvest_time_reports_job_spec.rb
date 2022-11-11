require 'rails_helper'

RSpec.describe FetchHarvestTimeReportsJob, type: :job do
  describe '#perform_now' do
    let(:date_range) { { from: Date.new(2022, 1, 1), to: Date.new(2022, 1, 31) } }
    let(:harvest_time_reports) do
      [
        {
          client_id: 1,
          project_name: 'Project 1',
          project_id: 1,
          billable_hours: 10
        },
        {
          client_id: 2,
          project_name: 'Project 2',
          project_id: 2,
          billable_hours: 20
        }
      ]
    end
    let(:get_time_reports) do
      instance_double(ClientResponse, success?: true, body: { results: harvest_time_reports })
    end
    let(:harvest_client) do
      instance_double(HarvestClient, get_time_reports: get_time_reports)
    end

    def perform
      described_class.perform_now(date_range)
    end

    before { allow(HarvestClient).to receive(:new).and_return(harvest_client) }

    it 'creates harvest client' do
      perform
      expect(HarvestClient).to have_received(:new)
    end

    it 'calls #get_time_reports method of harvest client' do
      perform
      expect(harvest_client).to have_received(:get_time_reports).with(date_range)
    end

    context 'when harvest client response is a success' do
      let(:customer1) { create(:customer, harvest_id: 1) }
      let!(:project1) { create(:project, customer: customer1, harvest_id: 1) }
      let(:customer2) { create(:customer, harvest_id: 2) }
      let!(:project2) { create(:project, customer: customer2, harvest_id: 2) }

      context 'when there are no saved time reports for the given month' do
        it { expect { perform }.to change { TimeReport.count }.by(2) }
      end

      context 'when there are saved time reports for the given month' do
        let!(:time_report1) do
          create(
            :time_report,
            project: project1,
            from: date_range[:from],
            to: date_range[:to],
            billable_hours: 5.0
          )
        end

        it 'updates billable hours of existing time reports' do
          perform
          expect(time_report1.reload.billable_hours).to eq(10.0)
        end

        it 'creates new time reports for projects that do not have them' do
          expect { perform }.to change { TimeReport.count }.by(1)
        end
      end

      context 'when time report params are invalid' do
        let(:harvest_time_reports) do
          [
            {
              project_id: 1,
              project_name: 'Project 1',
              client_id: 1,
              billable_hours: -10
            }
          ]
        end

        it 'does not create time report' do
          expect { perform }.to raise_error(ActiveRecord::RecordInvalid)
                            .and change { TimeReport.count }.by(0)
        end
      end

      context 'when customer does not exist' do
        let(:harvest_time_reports) do
          [
            {
              project_id: 1,
              project_name: 'Project 1',
              client_id: 3,
              billable_hours: 10
            }
          ]
        end

        it { expect { perform }.not_to(change { TimeReport.count }) }
      end

      context 'when project does not exist' do
        let(:harvest_time_reports) do
          [
            {
              project_id: 3,
              project_name: 'Project 1',
              client_id: 1,
              billable_hours: 10
            }
          ]
        end

        it 'does not create time reports' do
          expect { perform }.to raise_error(ActiveRecord::RecordNotFound)
                            .and change { TimeReport.count }.by(0)
        end
      end
    end

    context 'when harvest client response is a failure' do
      let(:get_time_reports) do
        instance_double(ClientResponse, success?: true, body: { results: harvest_time_reports })
      end

      it { expect { perform }.not_to(change { TimeReport.count }) }
    end
  end
end
