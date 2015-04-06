require 'faraday'
require 'json'

module GoogleDirectionsAPI
  class Base
    protected

    def get(path, params)
      params.merge!({ key: key })
      conn.get path, params
    end

    private

    def conn
      @conn ||= Faraday.new(url: 'https://maps.googleapis.com')
    end

    def key
      ENV['GOOGLE_API_KEY']
    end
  end
end
