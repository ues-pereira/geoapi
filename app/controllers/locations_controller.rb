class LocationsController < ApplicationController
  def address
    response = AddressLookupService.new(
      **permitted_params.to_h.symbolize_keys,
      geolocation_service: geolocation_service,
      repository: repository
    ).execute
    if response.success
      render json: response.data, status: :ok
    else
      render json: { error: response.error }, status: :unprocessable_entity
    end
  end

  private

  def permitted_params
    params.permit(:street, :city, :number, :state, :country)
  end

  def geolocation_service
    Services::GeocoderService
  end

  def repository
    Repositories::ActiveRecord
  end
end
