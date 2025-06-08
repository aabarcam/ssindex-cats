# HTTP call to external service error
class BadHTTPCallError < StandardError
  def initialize(message)
    super(message)
  end
end
