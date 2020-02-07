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

    def polyline
      data["routes"][0]["overview_polyline"]["points"]
    end

    def distance
      total_distance * 0.000621371
    end

    def duration
      total_duration / 60
    end

    def has_tolls?
      tolls_along_route?
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
      }.keep_if { |k,v| !v.nil? && !v.empty? }
    end

    def encode_waypoints
      return unless waypoints_present?
      "enc:#{GoogleDirectionsAPI::Polyline::Encoder.encode(waypoints)}:"
    end

    def data
      @data ||= JSON.parse(response.body)
    end

    def total_distance
      meters = 0
      data["routes"][0]["legs"].each do |leg|
        meters += leg["distance"]["value"]
      end

      meters
    end

    def total_duration
      seconds = 0
      data["routes"][0]["legs"].each do |leg|
        seconds += leg["duration"]["value"]
      end

      seconds
    end

    def tolls_along_route?
      data["routes"][0]["legs"].each do |leg|
        if leg["steps"].any? { |x| x["html_instructions"].try(:downcase).try(:include?, 'toll road') }
          return true
        end
      end

      false
    end

    def waypoints_present?
      return false if waypoints.nil? || waypoints.empty?

      return true
    end
  end
end
