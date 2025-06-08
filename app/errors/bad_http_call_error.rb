# HTTP call to external service error
class BadHttpCallError < StandardError
  def initialize(message)
    super(message)
  end
end
