module Services
  class GeocoderService < GeolocationService
    class << self
      def geocode_by_address(street:, number:, city:, state:, country:)
        address = [ street, number, city, state, country ].compact.join(",")
        result = Geocoder.search(address)&.first

        result.presence || []
      end
    end
  end
end
