require 'rails_helper'

RSpec.describe AddressLookupService, type: :service do
  let(:repository) { Repositories::ActiveRecord }
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

      expect(response.success?).to eq false
      expect(response.data).to be_empty
      expect(response.error).to eq 'Missing required parameters: city'
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

        expect(response.success?).to eq true
        expect(response.data).to have_attributes(coordinates)
        expect(response.error).to be_nil
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

          expect(response.success?).to eq true
          expect(response.data).to have_attributes(params)
          expect(response.error).to be_nil
          expect(response.data.persisted?).to eq true
        end
      end
    end
  end

  context 'when geolocation service fails' do
    let(:params) do
      {
        street: 'Avenida Paulista',
        number: 7,
        city: 'São Paulo',
        state: 'São Paulo',
        country: 'Brazil'
      }
    end

    it 'returns an error when geocoder service cannot find address' do
      allow(geolocation_service).to receive(:geocode_by_address).and_return([])

      response = service.execute

      expect(response.success?).to eq false
      expect(response.data).to be_empty
      expect(response.error).to eq "Geocoder not found for address: #{params.values.join(',')}"
    end

    it 'returns an error when geocoder service exceeds query limit' do
      allow(geolocation_service).to receive(:geocode_by_address).and_raise(Geocoder::OverQueryLimitError)

      response = service.execute

      expect(response.success?).to eq false
      expect(response.data).to be_empty
      expect(response.error).to eq "Over query limit: #{Geocoder::OverQueryLimitError}"
    end

    it 'returns an error when geocoder request is denied' do
      allow(geolocation_service).to receive(:geocode_by_address).and_raise(Geocoder::RequestDenied)

      response = service.execute

      expect(response.success?).to eq false
      expect(response.data).to be_empty
      expect(response.error).to eq "Request denied: #{Geocoder::RequestDenied}"
    end

    it 'returns an error when geocoder request is invalid' do
      allow(geolocation_service).to receive(:geocode_by_address).and_raise(Geocoder::InvalidRequest)

      response = service.execute

      expect(response.success?).to eq false
      expect(response.data).to be_empty
      expect(response.error).to eq "Invalid request: #{Geocoder::InvalidRequest}"
    end

    it 'returns an error when geocoder request time out' do
      allow(geolocation_service).to receive(:geocode_by_address).and_raise(Timeout::Error)

      response = service.execute

      expect(response.success?).to eq false
      expect(response.data).to be_empty
      expect(response.error).to eq "Geocoding request timed out: #{Timeout::Error}"
    end
  end
end
