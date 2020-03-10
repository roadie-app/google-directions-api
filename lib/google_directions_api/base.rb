require 'faraday'
require 'json'
require_relative './client_error'

module GoogleDirectionsAPI
  class Base
    protected

    def get(path, params)
      params.merge!({ key: key })
      conn.get(path, params).tap do |response|
        logger.send(log_level, "Url: #{response.env["url"].to_s}")
        logger.send(log_level, "Status: #{response.env["status"].to_s}")
        status = JSON.parse(response.body)["status"]
        raise ClientError.new(status: status) unless status == "OK"
      end
    end

    private

    def conn
      @conn ||= Faraday.new(url: url)
    end

    def key
      ENV['GOOGLE_API_KEY']
    end

    def url
      GoogleDirectionsAPI.configuration.url
    end

    def logger
      GoogleDirectionsAPI.configuration.logger
    end

    def log_level
      GoogleDirectionsAPI.configuration.log_level
    end
  end
end
