# Page requested exceeds total available pages
class RequestedPageDoesNotExist < StandardError
  def initialize(message)
    super(message)
  end
end
