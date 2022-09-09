class CmfClient < BaseClient
  BASE_URL = 'https://api.cmfchile.cl/api-sbifv3/recursos_api'
  CMF_API_KEY = ENV.fetch('CMF_API_KEY')

  def get_uf(date)
    path = "uf/#{date.strftime('%Y/%m/dias/%d')}"
    get(path, query: query_params)
  end

  private

  def query_params
    {
      apikey: CMF_API_KEY,
      formato: 'json'
    }
  end
end
