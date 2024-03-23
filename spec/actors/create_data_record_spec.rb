# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateDataRecord do
  describe '#result' do
    context 'with valid record attributes' do
      let(:valid_attributes) { { type: 'EpexDataRecord', value: 10.0, unit: 'kg', source: 'Source' } }

      it 'creates a new data record' do
        expect { described_class.result(record_attributes: valid_attributes) }.to change(EpexDataRecord, :count).by(1)
      end

      it 'returns a data record' do
        result = described_class.result(record_attributes: valid_attributes)
        expect(result.data_record).to be_a(EpexDataRecord)
        expect(result.data_record).to be_persisted
      end
    end

    context 'with invalid record attributes' do
      let(:invalid_attributes) { { type: "EpexDataRecord", value: nil, unit: nil, source: nil } }

      it 'does not create a new data record' do
        expect { described_class.result(record_attributes: invalid_attributes) }.not_to change(EpexDataRecord, :count)
      end

      it 'returns a failure with error message' do
        result = described_class.result(record_attributes: invalid_attributes)
        expect(result).to be_failure
        expect(result.error).to eq("Invalid record: value can't be blank, unit can't be blank, source can't be blank")
      end
    end
  end
end
