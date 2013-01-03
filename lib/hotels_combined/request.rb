module HotelsCombined
  class Request
    def self.city_search(options)
      request_params = map_params(options)
      request_params["CityID"] = options[:city_id]
      request_params["PageSize"] = options[:page_size] if options[:page_size]

      response = make_request(request_url("CitySearch", request_params))

      xml_doc = parse_response(decompress_response(response))
      xml_doc.xpath("//Hotel").map {|node|
        hotel = Hotel.from_xml(node)
        hotel.rates = node.xpath(".//Rate").map {|rate_node|
          Rate.from_xml(rate_node)
        }
        hotel
      }
    end

    private

    def self.format_date(date)
      raise ArgumentError, "Date is required" if date.nil?
      Chronic.parse(date).strftime("%Y-%m-%d")
    end

    def self.map_params(params)
      request_params = Hash.new
      request_params["Checkin"] = format_date(params[:checkin])
      request_params["Checkout"] = format_date(params[:checkout])
      request_params["Guests"] = params[:guests]
      request_params["Rooms"] = params[:rooms]
      request_params["UserID"] = params[:user_id]
      request_params["UserIPAddress"] = params[:user_ip_address]
      request_params["UserAgent"] = params[:user_agent]
      request_params["ApiKey"] = HotelsCombined.configuration.api_key
      request_params
    end

    def self.request_url(method, params)
      http_params = params.map {|key, value|
        "#{key}=#{URI::encode(value.to_s)}"
      }.join("&")

      URI.parse("#{HotelsCombined.base_url}#{method}?#{http_params}")
    end

    def self.make_request(url)
      request = Net::HTTP::Get.new(url.to_s, "Accept-Encoding" => "gzip")
      response = Net::HTTP.new(url.host, url.port).start do |http|
        http.request(request)
      end
    end

    def self.decompress_response(response)
      if response.header["Content-Encoding"] == "gzip"
        Zlib::GzipReader.new(StringIO.new(response.body)).read()
      else
        response.body
      end
    end

    def self.parse_response(response_body)
      xml_doc = Nokogiri::XML(response_body)
      xml_doc.remove_namespaces!

      if xml_doc.xpath("//Fault").count > 0
        error = xml_doc.at_xpath(".//Fault/Reason/Text").text
        raise(HotelsCombined.const_get(error.gsub("Error", "") + "Error"),
              "Fault: #{xml_doc.at_xpath(".//Fault/Code/Value").text}")
      end

      xml_doc
    end
  end
end
