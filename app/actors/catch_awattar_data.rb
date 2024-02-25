# frozen_string_literal: true

class CatchAwattarData < Actor
  input :starts_at
  input :ends_at, default: Time.zone.now

  def call
    awattar_data['data'].each do |awattar_record|
      starts_at = Time.zone.at(awattar_record['start_timestamp'] / 1000).strftime('%Y-%m-%d %H:%M:%S')
      ends_at = Time.zone.at(awattar_record['end_timestamp'] / 1000).strftime('%Y-%m-%d %H:%M:%S')
      value = awattar_record['marketprice'] * 100 / 1000 # original is EUR/MWh

      EpexDataRecord.create!(unit: 'ct/kWh',
                             value:,
                             starts_at:,
                             ends_at:,
                             source: 'awattar')
    end
  end

  private

  def awattar_data
    start_at_timestamp = starts_at.to_time.to_i * 1000 # awattar takes and gives epoch in miliseconds
    ends_at_timestamp = ends_at&.to_time&.to_i&.* 1000

    @awattar_data ||= HTTParty.get("https://api.awattar.at/v1/marketdata?start=#{start_at_timestamp}&end=#{ends_at_timestamp}")
  end
end
