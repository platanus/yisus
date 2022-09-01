class CreateDocumentJob < ApplicationJob
  queue_as :default

  UF_VALUE = 30000

  def perform(time_report_id)
    time_report = TimeReport.find(time_report_id)
    document_data = document_data(time_report)
    response = client.post_document(document_data)
    raise 'Bsale API error' unless response.success?

    document = response.body
    Document.create!(
      time_report_id: time_report_id,
      bsale_id: document[:id],
      url: document[:urlPdfOriginal]
    )
  end

  private

  def client
    @client ||= BsaleClient.new
  end

  def document_data(time_report)
    {
      codeSii: 33,
      officeId: 1,
      emissionDate: Time.zone.now.to_i,
      expirationDate: (Time.zone.now + 30.days).to_i,
      declareSii: 1,
      clientId: time_report.project.customer.bsale_id,
      details: document_details(time_report)
    }.to_json
  end

  def document_details(time_report)
    [{
      netUnitValue: time_report.project.unit_price * UF_VALUE,
      quantity: time_report.billable_hours,
      comment: I18n.l(time_report.from, format: "%B %Y").capitalize,
      taxId: [1]
    }]
  end
end
