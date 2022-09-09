class BsaleClient < BaseClient
  BASE_URL = 'https://api.bsale.cl/v1'
  BSALE_TOKEN = ENV.fetch('BSALE_TOKEN')

  def post_document(body)
    post('documents', suffix: '.json', body: body)
  end

  private

  def headers
    {
      'access_token' => BSALE_TOKEN,
      'Content-Type' => 'application/json'
    }
  end
end
