class HarvestClient
  BASE_URL = 'https://api.harvestapp.com/v2/'
  HARVEST_ACCOUNT_ID = ENV.fetch('HARVEST_ACCOUNT_ID')
  HARVEST_TOKEN = ENV.fetch('HARVEST_TOKEN')

  def get_time_reports(from, to)
    query_params = {
      from: format_date(from),
      to: format_date(to)
    }
    get_request('reports/time/projects', query_params)
  end

  private

  def headers
    {
      'Authorization' => "Bearer #{HARVEST_TOKEN}",
      'Harvest-Account-Id' => HARVEST_ACCOUNT_ID,
      'Content-Type' => 'application/json'
    }
  end

  def get_request(path, query_params = {})
    response = HTTParty.get(BASE_URL + path, headers: headers, query: query_params)
    ClientResponse.new(response)
  end

  def format_date(date)
    date.strftime('%Y%m%d')
  end
end
