require "net/http"
require "nokogiri"

require "hotels_combined/version"
require "hotels_combined/configuration"

module HotelsCombined
  LIVE_URL = "http://www.hotelscombined.com/API/Search.svc/pox/"
  SANDBOX_URL = "http://sandbox.hotelscombined.com/API/Search.svc/pox/"
  SANDBOX_API_KEY = "F7538EB2-2B63-4AE1-8C43-2FAD2D83EACB"

  def self.base_url
    if HotelsCombined.configuration.env == "production"
      LIVE_URL
    else
      SANDBOX_URL
    end
  end
end

require "hotels_combined/hotel"
require "hotels_combined/rate"
