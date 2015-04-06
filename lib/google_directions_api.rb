require "google_directions_api/version"
require "google_directions_api/configuration"
require "google_directions_api/directions"

module GoogleDirectionsAPI
  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
