module HotelsCombined
  class CitySearch
    include RequestHelpers

    attr_reader :xml, :hotels

    def initialize(options)
      request_params = map_params(options)
      request_params["CityID"] = options[:city_id]
      request_params["PageSize"] = options[:page_size] if options[:page_size]

      response = make_request(request_url("CitySearch", request_params))

      @xml = parse_response(decompress_response(response))
      @hotels = @xml.xpath("//Hotel").map {|node|
        hotel = Hotel.from_xml(node)
        hotel.rates = node.xpath(".//Rate").map {|rate_node|
          Rate.from_xml(rate_node)
        }
        hotel
      }
    end
  end
end
