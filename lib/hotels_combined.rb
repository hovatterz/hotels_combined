require "httparty"
require "nokogiri"

require "hotels_combined/version"
require "hotels_combined/configuration"

module HotelsCombined
  SANDBOX_URL = "http://sandbox.hotelscombined.com/API/Search.svc/pox/"
  LIVE_URL = "http://www.hotelscombined.com/API/Search.svc/pox/"

  def self.base_url
    if HotelsCombined.configuration.env == "production"
      LIVE_URL
    else
      SANDBOX_URL
    end
  end
end

require "hotels_combined/rate"
