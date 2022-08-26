class TimeReportsController < ApplicationController
  def index
    @time_reports = TimeReport.all.order(id: :desc).includes(:project, :document)
  end
end
