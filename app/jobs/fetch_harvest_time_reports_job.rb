class FetchHarvestTimeReportsJob < ApplicationJob
  queue_as :default

  DEFAULT_UNIT_PRICE = 1.8

  def perform(date)
    beginning_of_month, end_of_month = month_dates(date)
    response = client.get_time_reports(beginning_of_month, end_of_month)
    raise 'Harvest API error' unless response.success?

    harvest_time_reports = response.body[:results]
    ActiveRecord::Base.transaction do
      harvest_time_reports.each do |report|
        customer = Customer.find_by(harvest_id: report[:client_id])
        next unless customer

        project = upsert_project(customer, report[:project_name], report[:project_id])
        upsert_time_report(project, beginning_of_month, end_of_month, report[:billable_hours])
      end
    end
  end

  private

  def client
    @client ||= HarvestClient.new
  end

  def month_dates(date)
    [date.beginning_of_month, date.end_of_month]
  end

  def upsert_project(customer, name, harvest_id)
    Project.create_with(unit_price: DEFAULT_UNIT_PRICE)
           .find_or_create_by!(harvest_id: harvest_id) do |project|
      project.name = name
      project.customer = customer
    end
  end

  def upsert_time_report(project, beginning_of_month, end_of_month, billable_hours)
    TimeReport.find_or_create_by!(
      project: project,
      from: beginning_of_month,
      to: end_of_month
    ) do |time_report|
      time_report.billable_hours = billable_hours
    end
  end
end
