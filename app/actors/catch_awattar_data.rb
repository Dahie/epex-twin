# frozen_string_literal: true

class CatchAwattarData < Actor
  input :starts_at
  input :ends_at, default: Time.zone.now

  def call
    data['data'].each do |awattar_record|
      starts_at = timestap_to_formatted_string(awattar_record['start_timestamp'])
      ends_at = timestap_to_formatted_string(awattar_record['end_timestamp'])
      value = awattar_record['marketprice'] * 100 / 1000 # original is EUR/MWh

      record = AwattarSpotPriceRecord.find_or_create_by(starts_at:, ends_at:)
      record.update(unit: 'ct/kWh',
                    value:,
                    source: 'awattar')
    end
  end

  private

  def timestap_to_formatted_string(timestamp)
    Time.zone.at(timestamp / 1000).strftime('%Y-%m-%d %H:%M:%S')
  end

  def data
    @data ||= AwattarService.fetch(starts_at, ends_at)
  end
end
