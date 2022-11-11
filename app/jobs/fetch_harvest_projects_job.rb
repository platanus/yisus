class FetchHarvestProjectsJob < ApplicationJob
  queue_as :default

  DEFAULT_UNIT_PRICE = 1.8

  def perform
    response = client.get_projects
    harvest_projects = response.body[:projects]

    harvest_projects.each do |harvest_project|
      customer = Customer.find_by(harvest_id: harvest_project[:client][:id])
      next unless customer

      upsert_project(harvest_project, customer)
    end
  end

  private

  def client
    @client ||= HarvestClient.new
  end

  def upsert_project(harvest_project, customer)
    project = Project.find_or_initialize_by(harvest_id: harvest_project[:id])
    project.name = harvest_project[:name]
    project.unit_price = harvest_project[:hourly_rate] || DEFAULT_UNIT_PRICE
    project.customer = customer
    project.save!
    project
  end
end
