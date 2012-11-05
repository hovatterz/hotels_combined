module HotelsCombined
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :api_key, :env

    def initialize
      @api_key = "CHANGE ME"
      @env = "development"
    end
  end
end
