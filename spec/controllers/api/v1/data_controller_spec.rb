# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::DataController do
  describe 'POST #create' do
    let(:valid_data) do
      {
        data: {
          value: 0.9,
          unit: "m/s",
          source: "geosphere",
          type: "GeosphereWindRecord",
          starts_at: "2019-07-02T02:00:00.000+02:00",
          ends_at: "2019-07-02T03:00:00.000+02:00",
          created_at: "2024-02-25T10:34:02.392+01:00",
          updated_at: "2024-02-25T10:34:02.392+01:00"
        }
      }
    end

    context 'with valid token' do
      let(:valid_token) { ENV.fetch("EPEX_TWIN_API_TOKEN", nil) }

      before do
        request.headers['Authorization'] = "Bearer #{valid_token}"
      end

      it 'returns http success' do
        post :create, params: valid_data
        expect(response).to have_http_status(:success)
      end

      context 'with valid data' do
        it 'creates a new data record' do
          post :create, params: valid_data
          expect(response).to have_http_status(:created)
        end
      end

      context 'with invalid data' do
        let(:invalid_data) { { data: { invalid_param: 'invalid data' } } }

        it 'does not create a new data record' do
          post :create, params: invalid_data
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'with invalid token' do
      let(:invalid_token) { 'INVALID_BEARER_TOKEN' }

      before do
        request.headers['Authorization'] = "Bearer #{invalid_token}"
      end

      it 'returns http unauthorized' do
        post :create, params: valid_data
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'without token' do
      it 'returns http unauthorized' do
        post :create, params: valid_data
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
