class CmfClient
  BASE_URL = 'https://api.cmfchile.cl/api-sbifv3/recursos_api/'
  CMF_API_KEY = ENV.fetch('CMF_API_KEY')

  def get_uf(date)
    date_to_path = date.strftime('%Y/%m/dias/%d')
    get_request("uf/#{date_to_path}")
  end

  private

  def query_params
    {
      apikey: CMF_API_KEY,
      formato: 'json'
    }
  end

  def get_request(path)
    response = HTTParty.get(BASE_URL + path, query: query_params)
    ClientResponse.new(response)
  end
end
