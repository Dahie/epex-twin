# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EpexSpotAtHourlyBot do
  subject(:bot) { described_class.new }

  let(:now) { Time.new(2024, 3, 8, 10, 0, 0, '+02:00') }
  let(:record_now) { double(value_with_unit: '50 €/MWh', value: 50) }
  let(:record_next) { double(value_with_unit: '55 €/MWh', value: 55) }

  before do
    allow(Time).to receive_message_chain(:zone, :now).and_return(now)
    allow(bot).to receive(:find_data_record).with('2024-03-08 10:00:00.000').and_return(record_now)
    allow(bot).to receive(:find_data_record).with('2024-03-08 11:00:00.000').and_return(record_next)
  end

  it 'returns the message with current and next hour data' do
    expected_message = "EPEX Strompreis Österreich\n" \
                       "10-11 Uhr: 50 €/MWh\n" \
                       "11-12 Uhr: 55 €/MWh ↗️"

    expect(bot.message).to eq(expected_message)
  end
end
