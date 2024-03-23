# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::DataController do
  describe 'POST #create' do
    context 'with valid data' do
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
end
