class ClientResponse
  def initialize(response)
    @response = response
  end

  def body
    @body ||= @response.with_indifferent_access
  end

  def code
    @code ||= @response.code
  end

  def message
    @message ||= @response.message
  end

  def success?
    @success ||= @response.success?
  end
end
