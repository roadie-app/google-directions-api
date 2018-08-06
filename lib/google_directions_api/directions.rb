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
      }.keep_if { |k,v| !v.empty? }
    end

    def encode_waypoints
      return if waypoints.empty?
      "enc:#{GoogleDirectionsAPI::Polyline::Encoder.encode(waypoints)}:"
    end

    def data
      @data ||= JSON.parse(response.body)
    end

    def total_distance
      if waypoints.empty?
        data["routes"][0]["legs"][0]["distance"]["value"]
      else
        meters = 0
        data["routes"][0]["legs"].each do |leg|
          meters += leg["distance"]["value"]
        end
        return meters
      end
    end

    def total_duration
      if waypoints.empty?
        data["routes"][0]["legs"][0]["duration"]["value"]
      else
        seconds = 0
        data["routes"][0]["legs"].each do |leg|
          seconds += leg["duration"]["value"]
        end
        return seconds
      end
    end

    def tolls_along_route?
      if waypoints.empty?
        data["routes"][0]["legs"][0]["steps"].any? { |x| x["html_instructions"].try(:downcase).try(:include?, 'toll road') }
      else
        data["routes"][0]["legs"].each do |leg|
          next unless leg["steps"].any?

          if leg["steps"]["html_instructions"].try(:downcase).try(:include?, 'toll road')
            return true
          end
        end

        return false
      end
    end
  end
end
