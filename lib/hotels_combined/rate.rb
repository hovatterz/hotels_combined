module HotelsCombined
  class Rate
    attr_accessor :currency, :key, :price, :provider, :taxes

    def initialize(data)
      data.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    def supplier_link(splash = false, label = "")
      @supplier_link ||= "#{HotelsCombined.configuration.private_branding_url}ProviderRedirect.aspx?Key=#{key}&Label=#{label}&Splash=#{splash}"
    end

    def self.from_xml(node)
      Rate.new({
        :price => node.at_xpath(".//ConvertedPrice").text.to_f,
        :taxes => node.at_xpath(".//ConvertedTaxes").text.to_f,
        :currency => node.at_xpath(".//Currency").text,
        :key => node.at_xpath(".//Key").text,
        :provider => node.at_xpath(".//Provider").text
      })
    end
  end
end
