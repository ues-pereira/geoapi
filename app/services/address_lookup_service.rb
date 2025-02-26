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

    # geolocation = fetch_geolocation
    binding.pry
    location = repository.create!(
      street: fetch_geolocation.street,
      number: fetch_geolocation.house_number.to_i,
      city: fetch_geolocation.city,
      state: fetch_geolocation.state,
      country: fetch_geolocation.country,
      latitude: fetch_geolocation.latitude,
      longitude: fetch_geolocation.longitude
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
    @fetch_geolocation ||= geolocation_service.geocode_by_address(**address.compact)

    GeoLocationNotFound if @fetch_geolocation.blank?

    @fetch_geolocation
  end

  def response(success:, location:, error: nil)
    OpenStruct.new(success:, location:, error:)
  end
end
