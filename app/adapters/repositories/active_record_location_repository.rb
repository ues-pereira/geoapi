module Repositories
  class ActiveRecordLocationRepository < LocationRepository
    class << self
      def find_by_address(street:, city:, state:, number:, country:)
        Location.find_by(street: street, city: city, state: state, number: number, country: country)
      end

      def create!(street:, number:, city:, state:, country:, latitude:, longitude:)
        Location.create!(street:, number:, city:, state:, country:, latitude:, longitude:)
      end
    end
  end
end
