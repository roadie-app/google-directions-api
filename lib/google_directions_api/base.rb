require 'faraday'
require 'json'

module GoogleDirectionsAPI
  class Base
    protected

    def get(path, params)
      params.merge!({ key: key })
      conn.get(path, params).tap do |response|
        logger.send(log_level, "Url: #{response.env["url"].to_s}")
        logger.send(log_level, "Status: #{response.env["status"].to_s}")
        logger.send(log_level, "Body: #{response.body}")
      end
    end

    private

    def conn
      @conn ||= Faraday.new(url: 'https://maps.googleapis.com')
    end

    def key
      ENV['GOOGLE_API_KEY']
    end

    def logger
      GoogleDirectionsAPI.configuration.logger
    end

    def log_level
      GoogleDirectionsAPI.configuration.log_level
    end
  end
end
