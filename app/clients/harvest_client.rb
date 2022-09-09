class HarvestClient < BaseClient
  BASE_URL = 'https://api.harvestapp.com/v2'
  HARVEST_ACCOUNT_ID = ENV.fetch('HARVEST_ACCOUNT_ID')
  HARVEST_TOKEN = ENV.fetch('HARVEST_TOKEN')

  def get_time_reports(date_range)
    get('reports/time/projects', query: date_range)
  end

  private

  def headers
    {
      'Authorization' => "Bearer #{HARVEST_TOKEN}",
      'Harvest-Account-Id' => HARVEST_ACCOUNT_ID,
      'Content-Type' => 'application/json'
    }
  end
end
