require 'rails_helper'

RSpec.describe 'Locations API', type: :request do
  context 'GET /locations/address' do
    it 'returns a geolocation given address' do
      params = {
        street: 'Avenida Paulista',
        number: 7,
        city: 'São Paulo',
        state: 'São Paulo',
        country: 'Brazil'
      }

      VCR.use_cassette("geocoder_response") do
        get '/locations/address', params: params, headers: { "ACCEPT" => "application/json" }
        response_body = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:ok)
        expect(response_body.keys).to match_array([ :street, :number, :city, :state, :country, :latitude, :longitude ])
      end
    end

    it 'returns error message when missing mandatory parameters' do
      params = {
        street: 'Avenida Paulista',
        number: 7,
        city: '',
        state: 'São Paulo',
        country: 'Brazil'
      }
      get '/locations/address', params: params, headers: { "ACCEPT" => "application/json" }
      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_body[:error]).to eq 'Missing required parameters: city'
    end
  end
end
