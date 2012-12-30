module HotelsCombined
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :api_key, :env, :private_branding_url

    def initialize
      @api_key = "CHANGE ME"
      @env = "development"
      @private_branding_url = "CHANGE ME"
    end

    def api_key
      return HotelsCombined::SANDBOX_API_KEY unless @env == "production"
      @api_key
    end
  end
end
