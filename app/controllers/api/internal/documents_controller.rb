class Api::Internal::DocumentsController < Api::Internal::BaseController
  def create
    document = CreateDocumentJob.perform_now(document_params[:time_report_id])
    respond_with document
  end

  private

  def document_params
    params.require(:document).permit(:time_report_id)
  end
end
