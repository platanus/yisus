class FetchHarvestDataJob < ApplicationJob
  queue_as :default

  def perform(date_range)
    FetchHarvestProjectsJob.perform_now
    FetchHarvestTimeReportsJob.perform_now(date_range)
  end
end
