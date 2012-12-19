module HotelsCombined
  class InvalidLoginError < StandardError; end
  class HotelDoesNotExistError < StandardError; end
  class CityDoesNotExistError < StandardError; end
  class InvalidSearchIDError < StandardError; end
  class InvalidParameterError < StandardError; end
  class CompressionRequiredError < StandardError; end
  class ServerError < StandardError; end
end
