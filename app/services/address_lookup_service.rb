#  frozen_string_literal: true

class AddressLookupService
  class MissingParams < StandardError; end
  class GeoLocationNotFound < StandardError; end

  attr_reader :repository, :geolocation_service, :street, :city, :number, :state, :country

  def initialize(repository:, geolocation_service:, street:, city:, number:, state:, country:)
    @repository = repository
    @geolocation_service = geolocation_service
    @street = street
    @city = city
    @number = number
    @state = state
    @country = country
  end

  def execute
    validate_params

    location = repository.find_by_address(**address.compact)
    return response(success: true, location: location) if location.present?

    geolocation = fetch_geolocation
    location = repository.create!(
      street: geolocation.street,
      number: geolocation.house_number.to_i,
      city: geolocation.city,
      state: geolocation.state,
      country: geolocation.country,
      latitude: geolocation.latitude,
      longitude: geolocation.longitude
    )

    response(success: true, location: location)
  rescue MissingParams
    response(success: false, location: [])
  rescue GeoLocationNotFound
    response(success: false, location: [])
  end

  private

  def address
    { street: street, number: number, city: city, state: state, country: country }
  end

  def validate_params
    return if address.except(:number).values.all?(&:present?)

    raise MissingParams
  end

  def fetch_geolocation
    @fetch_geolocation ||= begin
      geolocation = geolocation_service.geocode_by_address(**address.compact)

      return geolocation if geolocation.present?

      raise GeoLocationNotFound
    end
  end

  def response(success:, location:, error: nil)
    OpenStruct.new(success:, location:, error:)
  end
end
