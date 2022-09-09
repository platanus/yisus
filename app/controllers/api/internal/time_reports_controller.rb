class Api::Internal::TimeReportsController < Api::Internal::BaseController
  def index
    respond_with TimeReport.where(time_reports_date_range).includes(:project, :document)
  end

  def create
    respond_with FetchHarvestTimeReportsJob.perform_now(time_reports_date_range)
  end

  private

  def time_reports_date_range
    {
      from: params[:date].to_date.beginning_of_month,
      to: params[:date].to_date.end_of_month
    }
  end
end
