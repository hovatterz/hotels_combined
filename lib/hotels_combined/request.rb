module HotelsCombined
  class Request
    def self.city_search(params)
      request_params = Hash.new
      request_params["CityID"] = params[:city_id]
      request_params["Checkin"] = format_date(params[:checkin])
      request_params["Checkout"] = format_date(params[:checkout])
      request_params["Guests"] = params[:guests]
      request_params["Rooms"] = params[:rooms]
      request_params["UserID"] = params[:user_id]
      request_params["UserIPAddress"] = params[:user_ip_address]
      request_params["UserAgent"] = params[:user_agent]
      request_params["ApiKey"] = HotelsCombined.configuration.api_key
      request_params["PageSize"] = params[:page_size] if params[:page_size]

      http_params = request_params.map {|key, value| "#{key}=#{URI::encode(value.to_s)}" }.join("&")

      url = URI.parse("#{HotelsCombined.base_url}CitySearch?#{http_params}")

      request = Net::HTTP::Get.new("#{HotelsCombined.base_url}CitySearch?#{http_params}", { "Accept-Encoding" => "gzip" })
      response = Net::HTTP.new(url.host, url.port).start do |http|
        http.request(request)
      end

      xml_doc = Nokogiri::XML(decompress_response(response))
      xml_doc.remove_namespaces!

      if xml_doc.xpath("//Fault").count > 0
        error = xml_doc.at_xpath(".//Fault/Reason/Text").text
        raise(HotelsCombined.const_get(error.gsub("Error", "") + "Error"),
              "Fault: #{xml_doc.at_xpath(".//Fault/Code/Value").text}")
      end

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

    def self.decompress_response(response)
      if response.header["Content-Encoding"] == "gzip"
        Zlib::GzipReader.new(StringIO.new(response.body)).read()
      else
        response.body
      end
    end
  end
end
