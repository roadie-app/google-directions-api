require 'logger'

module GoogleDirectionsAPI
  class Configuration
    attr_writer :logger
    attr_writer :log_level

    def logger
      @logger ||= Logger.new('/dev/null')
    end

    def log_level
      @log_level ||= :info
    end
  end
end
