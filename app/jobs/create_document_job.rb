class CreateDocumentJob < ApplicationJob
  queue_as :default

  def perform(time_report_id)
    @time_report = TimeReport.find(time_report_id)

    document = post_bsale_document
    Document.create!(
      time_report_id: time_report_id,
      bsale_id: document['id'],
      url: document['urlPdfOriginal']
    )
  end

  private

  def bsale_client
    @bsale_client ||= BsaleClient.new
  end

  def cmf_client
    @cmf_client ||= CmfClient.new
  end

  def get_uf_value
    last_day_date = @time_report.to
    response = cmf_client.get_uf(last_day_date)

    response.body['UFs'][0]['Valor'].gsub(/[.,]/, '.' => '', ',' => '.').to_f
  end

  def document_data
    {
      codeSii: 34,
      officeId: 1,
      emissionDate: Time.zone.now.to_i,
      expirationDate: Time.zone.now.to_i,
      declareSii: 1,
      clientId: @time_report.project.customer.bsale_id,
      details: document_details
    }.to_json
  end

  def document_details
    [{
      netUnitValue: document_detail_net_unit_value,
      quantity: @time_report.billable_hours,
      comment: document_detail_comment
    }]
  end

  def document_detail_net_unit_value
    (@time_report.project.unit_price * get_uf_value).round
  end

  def document_detail_comment
    project_name = @time_report.project.name
    month = I18n.l(@time_report.from, format: '%B %Y').capitalize
    "Desarrollo proyecto #{project_name} - #{month}"
  end

  def post_bsale_document
    response = bsale_client.post_document(document_data)
    response.body
  end
end
