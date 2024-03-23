# frozen_string_literal: true

class CreateDataRecord < Actor
  input :record_attributes
  output :data_record

  def call
    self.data_record = DataRecord.new(record_attributes)

    fail!(error: "Invalid record: #{data_record.errors.messages.map{ |m, v| "#{m} #{v.join(', ')}" }.join(', ')}") unless data_record.valid?

    data_record.save
  end
end
