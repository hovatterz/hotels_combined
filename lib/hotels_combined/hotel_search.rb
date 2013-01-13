module HotelsCombined
  class HotelSearch
    include RequestHelpers

    attr_reader :xml, :rates

    def initialize(options)
      request_params = map_params(options)
      request_params["HotelID"] = options[:hotel_id]

      response = make_request(request_url("HotelSearch", request_params))

      @xml = parse_response(decompress_response(response))
      @rates = @xml.xpath("//Rate").map {|node|
        Rate.from_xml(node)
      }
    end
  end
end
