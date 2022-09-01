require 'rails_helper'

RSpec.describe FetchHarvestTimeReportsJob, type: :job do
  describe '#perform_now' do
    let(:date) { Date.new(2022, 1, 1) }
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
      described_class.perform_now(date)
    end

    before { allow(HarvestClient).to receive(:new).and_return(harvest_client) }

    it 'creates harvest client' do
      perform
      expect(HarvestClient).to have_received(:new)
    end

    it 'calls #get_time_reports method of harvest client' do
      perform
      expect(harvest_client).to have_received(:get_time_reports)
        .with(date.beginning_of_month, date.end_of_month)
    end

    context 'when harvest client response is a success' do
      let!(:customer1) do
        create(:customer, harvest_id: 1) do |customer|
          create(:project, customer: customer, harvest_id: 1)
        end
      end
      let!(:customer2) do
        create(:customer, harvest_id: 2) do |customer|
          create(:project, customer: customer, harvest_id: 2)
        end
      end

      context 'when there are no time reports for the given month' do
        it { expect { perform }.to change { TimeReport.count }.by(2) }
      end

      context 'when there are time reports for the given month' do
        before do
          create(:time_report,
                 project: customer1.projects.first,
                 from: date.beginning_of_month,
                 to: date.end_of_month)
        end

        it { expect { perform }.to change { TimeReport.count }.by(1) }
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

        it { expect { perform }.to change { TimeReport.count }.by(0) }
      end

      context 'when project does not exist' do
        context 'when project params are valid' do
          let(:harvest_time_reports) do
            [
              {
                project_id: 3,
                project_name: 'Project 3',
                client_id: 1,
                billable_hours: 10
              }
            ]
          end

          it { expect { perform }.to change { Project.count }.by(1) }
          it { expect { perform }.to change { TimeReport.count }.by(1) }
        end

        context 'when project params are invalid' do
          let(:harvest_time_reports) do
            [
              {
                project_id: nil,
                project_name: nil,
                client_id: 1,
                billable_hours: 10
              }
            ]
          end

          it 'does not create projects and time reports' do
            expect { perform }.to raise_error(ActiveRecord::RecordInvalid)
                              .and change { Project.count }.by(0)
                              .and change { TimeReport.count }.by(0)
          end
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
