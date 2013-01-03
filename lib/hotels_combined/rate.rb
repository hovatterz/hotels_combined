module HotelsCombined
  class Rate
    attr_accessor :currency, :key, :price, :provider, :provider_name,
      :taxes

    def initialize(data)
      data.each do |key, value|
        instance_variable_set("@#{key}", value)
      end

      @provider_name = PROVIDERS[provider]
    end

    def supplier_link(splash = false, label = "")
      @supplier_link ||= "http://brands.datahc.com/ProviderRedirect.aspx?Key=#{key}&Label=#{label}&Splash=#{splash}&a_aid=#{HotelsCombined.configuration.affiliate_id}&brandid=#{HotelsCombined.configuration.brand_id}"
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
