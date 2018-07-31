require_relative './base'
require_relative './polyline/encoder'

module GoogleDirectionsAPI
  class Directions < Base
    attr_accessor :to
    attr_accessor :from
    attr_accessor :waypoints

    def self.new_for_locations(from:, to:, waypoints: nil)
      new.tap do |d|
        d.to = to
        d.from = from
        d.waypoints = waypoints
      end
    end

    def distance
      meters = data["routes"][0]["legs"][0]["distance"]["value"]
      meters * 0.000621371
    end

    def duration
      seconds = data["routes"][0]["legs"][0]["duration"]["value"]
      seconds / 60
    end

    def polyline
      data["routes"][0]["overview_polyline"]["points"]
    end

    def has_tolls?
      data["routes"][0]["legs"][0]["steps"].any? { |x| x["html_instructions"].try(:downcase).try(:include?, 'toll road') }
    end

    private

    def response
      @response ||= get "/maps/api/directions/json", request_params
    end

    def request_params
      {
          origin: from,
          destination: to,
          waypoints: encode_waypoints
      }.keep_if { |k,v| v.present? }
    end

    def encode_waypoints
      return unless waypoints.present?
      "enc:#{GoogleDirectionsAPI::Polyline::Encoder.encode(waypoints)}:"
    end

    def data
      @data ||= JSON.parse(response.body)
    end
  end
end
