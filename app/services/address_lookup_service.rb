#  frozen_string_literal: true

class AddressLookupService
  class MissingParams < StandardError; end
  class GeoLocationNotFound < StandardError; end

  attr_reader :repository, :geolocation_service, :street, :city, :number, :state, :country, :result

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
    return Result.success(location) if location.present?

    location = repository.create!(
      street: fetch_geolocation.street,
      number: fetch_geolocation.house_number.to_i,
      city: fetch_geolocation.city,
      state: fetch_geolocation.state,
      country: fetch_geolocation.country,
      latitude: fetch_geolocation.latitude,
      longitude: fetch_geolocation.longitude
    )

    Result.success(location)
  rescue MissingParams => e
    Result.failure(e.message)
  rescue GeoLocationNotFound
    Result.failure([])
  end

  private

  def address
    { street: street, number: number, city: city, state: state, country: country }
  end

  def validate_params
    missing_keys = address.except(:number).select { |_, value| value.blank? }

    raise MissingParams, "Missing required parameters: #{missing_keys.keys.join(', ')}" if missing_keys.any?
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
