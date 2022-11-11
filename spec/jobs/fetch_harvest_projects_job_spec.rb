require 'rails_helper'

RSpec.describe FetchHarvestProjectsJob, type: :job do
  describe '#perform_now' do
    let(:harvest_projects) do
      {
        projects: [
          {
            id: 1,
            name: 'Project 1',
            hourly_rate: 1.8,
            client: {
              id: 1
            }
          },
          {
            id: 2,
            name: 'Project 2',
            hourly_rate: 1.3,
            client: {
              id: 2
            }
          }
        ]
      }
    end
    let(:get_projects) { instance_double(ClientResponse, success?: true, body: harvest_projects) }
    let(:client) { instance_double(HarvestClient, get_projects: get_projects) }

    def perform
      described_class.perform_now
    end

    before { allow(HarvestClient).to receive(:new).and_return(client) }

    it 'calls #get_projects method of harvest client' do
      perform
      expect(client).to have_received(:get_projects)
    end

    context 'when harvest client response is a success' do
      let!(:customer1) { create(:customer, harvest_id: 1) }
      let!(:customer2) { create(:customer, harvest_id: 2) }

      context 'when some projects already exist' do
        let!(:project1) do
          create(:project, harvest_id: 1, name: 'Project 0', unit_price: 2.0, customer: customer1)
        end

        it 'updates existing projects' do
          perform
          expect(project1.reload).to have_attributes({ name: 'Project 1', unit_price: 1.8 })
        end

        it { expect { perform }.to change { Project.count }.by(1) }
      end

      context 'when no projects exist' do
        it { expect { perform }.to change { Project.count }.by(2) }
      end

      context 'when a customer does not exist' do
        let(:harvest_projects) do
          {
            projects: [
              {
                id: 1,
                name: 'Project 1',
                hourly_rate: 1.8,
                client: {
                  id: 1
                }
              },
              {
                id: 3,
                name: 'Project 3',
                hourly_rate: 1.3,
                client: {
                  id: 3
                }
              }
            ]
          }
        end

        it { expect { perform }.to change { Project.count }.by(1) }
      end
    end
  end
end
