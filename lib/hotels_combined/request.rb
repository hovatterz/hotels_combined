module HotelsCombined
  class Request
    def self.city_search(params)
      request_params = Hash.new
      request_params["CityID"] = params[:city_id]
      request_params["Checkin"] = params[:arrival]
      request_params["Checkout"] = params[:departure]
      request_params["Guests"] = params[:guests]
      request_params["Rooms"] = params[:rooms]
      request_params["UserID"] = params[:user_id]
      request_params["UserIPAddress"] = params[:user_ip_address]
      request_params["UserAgent"] = params[:user_agent]
      request_params["ApiKey"] = HotelsCombined.configuration.api_key

      http_params = request_params.map {|key, value| "#{key}=#{value}" }.join("&")

      url = URI.parse("#{HotelsCombined.base_url}CitySearch?#{http_params}")

      request = Net::HTTP::Get.new("#{HotelsCombined.base_url}CitySearch?#{http_params}", { "Accept-Encoding" => "gzip" })
      response = Net::HTTP.new(url.host, url.port).start do |http|
        http.request(request)
      end

      xml_doc = Nokogiri::XML(response.body)
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
  end
end
