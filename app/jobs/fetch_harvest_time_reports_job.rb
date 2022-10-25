class FetchHarvestTimeReportsJob < ApplicationJob
  queue_as :default

  DEFAULT_UNIT_PRICE = 1.8

  def perform(date_range)
    response = client.get_time_reports(date_range)
    harvest_time_reports = response.body[:results]
    ActiveRecord::Base.transaction do
      harvest_time_reports.each do |report|
        customer = Customer.find_by(harvest_id: report[:client_id])
        next unless customer

        project = upsert_project(customer, report[:project_name], report[:project_id])
        upsert_time_report(project, date_range[:from], date_range[:to], report[:billable_hours])
      end
    end

    TimeReport.where(date_range)
  end

  private

  def client
    @client ||= HarvestClient.new
  end

  def upsert_project(customer, name, harvest_id)
    project = Project.find_or_initialize_by(harvest_id: harvest_id)
    project.name = name
    project.customer = customer
    project.unit_price = DEFAULT_UNIT_PRICE
    project.save!
    project
  end

  def upsert_time_report(project, beginning_of_month, end_of_month, billable_hours)
    time_report = TimeReport.find_or_initialize_by(
      project: project,
      from: beginning_of_month,
      to: end_of_month
    )
    time_report.billable_hours = billable_hours
    time_report.save!
    time_report
  end
end
