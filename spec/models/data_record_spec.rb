# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DataRecord do
  describe '#value_with_unit' do
    let(:data_record) { described_class.new(value: 10.0, unit: 'kg') }

    it 'returns the value with unit' do
      expect(data_record.value_with_unit).to eq('10.0 kg')
    end
  end
end
