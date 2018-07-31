module GoogleDirectionsAPI
  module Polyline
    class Decoder
      def self.decode(polyline, precision = 1e5)
        coords = []
        acc = ""
        polyline.each_byte do |b|
          acc << b
          next unless b < 0x5f
          coords << acc
          acc = ""
        end
        lat = lng = 0
        coords.each_slice(2).map do |coords_pair|
          lat += decode_number(coords_pair[0], precision)
          lng += decode_number(coords_pair[1], precision)
          [lat, lng]
        end
      end

      private

      def self.decode_number(string, precision = 1e5)
        result = 1
        shift = 0
        string.each_byte do |b|
          b = b - 63 - 1
          result += b << shift
          shift += 5
        end
        result = (result & 1).nonzero? ? (~result >> 1) : (result >> 1)
        result / precision
      end
    end
  end
end
