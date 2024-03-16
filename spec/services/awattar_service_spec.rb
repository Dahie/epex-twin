# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AwattarService do
  describe '.fetch' do
    let(:starts_at) { Time.zone.at(1561932000) }
    let(:ends_at) { Time.zone.at(1564610400) } # One hour later

    it 'fetches data from the Awattar API' do
      VCR.use_cassette('awattar_fetch_data') do
        data = described_class.fetch(starts_at, ends_at)
        expect(data).to be_an(Hash)
        expect(data['data'].size).to eq(744)
        data['data'].each do |entry|
          expect(entry).to have_key('start_timestamp')
          expect(entry).to have_key('end_timestamp')
          expect(entry).to have_key('marketprice')
          expect(entry['start_timestamp']).to be_a(Integer)
          expect(entry['end_timestamp']).to be_a(Integer)
          expect(entry['marketprice']).to be_a(Numeric)
        end
      end
    end
  end
end
