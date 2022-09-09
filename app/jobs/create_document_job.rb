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
    response = cmf_client.get_uf(Date.current)

    response.body['UFs'][0]['Valor'].gsub(/[.,]/, '.' => '', ',' => '.').to_f
  end

  def document_data
    {
      codeSii: 33,
      officeId: 1,
      emissionDate: Time.zone.now.to_i,
      expirationDate: (Time.zone.now + 30.days).to_i,
      declareSii: 1,
      clientId: @time_report.project.customer.bsale_id,
      details: document_details
    }.to_json
  end

  def document_details
    [{
      netUnitValue: @time_report.project.unit_price * get_uf_value,
      quantity: @time_report.billable_hours,
      comment: I18n.l(@time_report.from, format: "%B %Y").capitalize,
      taxId: [1]
    }]
  end

  def post_bsale_document
    response = bsale_client.post_document(document_data)
    response.body
  end
end
