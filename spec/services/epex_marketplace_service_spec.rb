# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EpexMarketplaceService do
  describe '#fetch' do
    let(:service) { described_class.new }
    let(:trading_date) { Time.zone.at(1710602412) }
    let(:delivery_date) { trading_date + 1.day }
    let(:url) do
      "https://www.epexspot.com/en/market-data?market_area=AT&trading_date=#{trading_date.strftime('%Y-%m-%d')}&delivery_date=#{delivery_date.strftime('%Y-%m-%d')}&modality=Auction&sub_modality=DayAhead&technology=&product=60&data_mode=table"
    end

    before { Timecop.freeze(trading_date) }
    after { Timecop.return }

    it 'fetches data from the EPEX marketplace' do
      VCR.use_cassette('epex_fetch_data') do
        expect(HTTP).to receive(:get).with(url).and_call_original
        service.fetch
      end
    end

    context 'with valid HTML response' do
      it 'returns data in the expected format' do
        VCR.use_cassette('epex_valid_html') do
          data = service.fetch
          expect(data).to be_an(Array)
          expect(data.size).to eq(24)
          data.each do |entry|
            expect(entry).to have_key(:starts_at)
            expect(entry).to have_key(:ends_at)
            expect(entry).to have_key(:value)
            expect(entry[:starts_at]).to be_a(DateTime)
            expect(entry[:ends_at]).to be_a(DateTime)
            expect(entry[:value]).to be_a(Float)
          end
        end
      end
    end

    context 'with invalid HTML response' do
      it 'raises an error' do
        VCR.use_cassette('epex_invalid_html') do
          allow(HTTP).to receive(:get).and_return('invalid html')
          expect { service.fetch }.to raise_error(StandardError)
        end
      end
    end

    context 'when fetch before 1pm' do
      pending('needs fetch in the morning')
    end
  end
end
