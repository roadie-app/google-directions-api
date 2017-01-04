require_relative './base'

module GoogleDirectionsAPI
  class Directions < Base
    attr_accessor :to
    attr_accessor :from

    def self.new_for_locations(from:, to:)
      new.tap do |d|
        d.to = to
        d.from = from
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
      data["routes"][0]["legs"][0]["steps"].any? { |x| x.["html_instructions"].try(:downcase).try(:include?, 'toll road') }
    end

    private

    def response
      @response ||= get "/maps/api/directions/json",
                      origin: from,
                      destination: to
    end

    def data
      @data ||= JSON.parse(response.body)
    end
  end
end
