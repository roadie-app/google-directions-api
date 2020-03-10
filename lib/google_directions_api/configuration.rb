require 'logger'

module GoogleDirectionsAPI
  class Configuration
    attr_writer :logger, :log_level, :url

    def logger
      @logger ||= Logger.new('/dev/null')
    end

    def log_level
      @log_level ||= :info
    end

    def url
      @url ||= 'https://maps.googleapis.com'
    end
  end
end
