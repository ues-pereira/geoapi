class LocationRepository
  def find_by_address(street:, city:, state:, number:, country:)
    raise NoImplementeError
  end

  def create!(street:, number:, city:, state:, country:, latitude:, longitude:)
    raise NotImplementedError
  end
end
