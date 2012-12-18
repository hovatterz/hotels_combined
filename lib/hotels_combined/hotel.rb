module HotelsCombined
  class Hotel
    attr_accessor :id, :rates

    def initialize(data)
      data.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    def self.from_xml(node)
      Hotel.new({
        :id => node.at_xpath(".//ID").text.to_i
      })
    end
  end
end
