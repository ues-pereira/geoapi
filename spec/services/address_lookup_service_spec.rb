require 'rails_helper'

RSpec.describe AddressLookupService, type: :service do
  let(:repository) { Repositories::ActiveRecordLocationRepository }
  let(:geolocation_service) { Services::GeocoderService }
  let(:service) { described_class.new(**params.merge(repository: repository, geolocation_service: geolocation_service)) }

  context 'when missing params' do
    let(:params) do
      {
        street: 'Avenida Paulista',
        number: 7,
        city: nil,
        state: 'São Paulo',
        country: 'Brazil'
      }
    end

    it 'returns an unsuccessful response' do
      response = service.execute

      expect(response.success).to eq false
      expect(response.location).to be_empty
    end
  end

  context 'when gives valid parameters' do
    let(:params) do
      {
        street: 'Avenida Paulista',
        number: 7,
        city: 'São Paulo',
        state: 'São Paulo',
        country: 'Brazil'
      }
    end

    context 'when the location is stored in the database' do
      let(:coordinates) { { latitude: 37.7941013, longitude: -122.3951096 } }

      before do
        Location.create(**params.merge(coordinates))
      end

      it 'returns a successful response with the stored coordinates' do
        response = service.execute

        expect(response.success).to eq true
        expect(response.location).to have_attributes(coordinates)
      end

      it 'does not call the geolocation service' do
        allow(geolocation_service).to receive(:geocode_by_address)

        service.execute

        expect(geolocation_service).not_to have_received(:geocode_by_address)
      end
    end

    context 'when the location is not stored in the database' do
      let(:coordinates) { { latitude: 37.7941013, longitutde: -122.3951096 } }

      it 'calls the geolocation service to fetch coordinates' do
        VCR.use_cassette("geocoder_response") do
          response = service.execute

          expect(response.location).to have_attributes(params)
        end
      end
    end
  end
end
