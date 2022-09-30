class BaseClient
  private

  def headers; end

  def base_url
    unless self.class.const_defined?('BASE_URL')
      raise StandardError, "#{self.class}::BASE_URL is not defined"
    end

    self.class::BASE_URL
  end

  def get(path, options = {})
    request(:get, path, options)
  end

  def post(path, options = {})
    request(:post, path, options)
  end

  def request(method, path, options = {})
    url = build_uri(path, options[:suffix])
    options = { headers: headers, query: options[:query], body: options[:body] }
    response = HTTParty.send(method, url, options)

    Rails.logger.info(
      "#{self.class.name} request to url=#{url} "\
      "answered with status=#{response.code} and body=#{response.body}"
    )
    raise StandardError, "#{self.class}: #{response}" unless response.success?

    ClientResponse.new(response)
  end

  def build_uri(path, suffix = nil)
    URI("#{base_url}/#{path}#{suffix}")
  end
end
