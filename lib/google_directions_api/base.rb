require 'faraday'
require 'json'

module GoogleDirectionsAPI
  class Base
    protected

    def get(path, params)
      params.merge!({ key: key })
      params_string = params.map do |k,v|
                        "#{k.to_s}=#{v.to_s}"
                      end.join('&')
      conn.get "#{path}?#{params_string}"
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
