class BsaleClient
  BASE_URL = 'https://api.bsale.cl/v1'
  BSALE_TOKEN = ENV.fetch('BSALE_TOKEN')

  def post_document(body)
    post_request('/documents', body)

  end

  private

  def headers
    {
      'access_token' => BSALE_TOKEN,
      'Content-Type' => 'application/json'
    }
  end

  def post_request(path, body)
    full_url = [BASE_URL, path, '.json'].join
    response = HTTParty.post(full_url, headers: headers, body: body)
    ClientResponse.new(response)
  end
end
