# Page size requested is not a positive integer
class NonPositiveIdError < StandardError
  def initialize(message)
    super(message)
  end
end
