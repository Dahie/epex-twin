# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MeteoblueBasicService do
  describe '.fetch' do
    context 'with valid API token' do
      before do
        allow(ENV).to receive(:fetch).with('METEOBLUE_API_TOKEN', nil).and_return('test')
      end

      it 'returns weather data' do
        VCR.use_cassette('meteoblue_basic_fetch_data') do
          expect(described_class.fetch).to include('data_1h')
        end
      end
    end

    context 'with missing API token' do
      before do
        allow(ENV).to receive(:fetch).with('METEOBLUE_API_TOKEN', nil).and_return(nil)
      end

      it 'raises an error' do
        expect { described_class.fetch }.to raise_error(StandardError)
      end
    end
  end
end
