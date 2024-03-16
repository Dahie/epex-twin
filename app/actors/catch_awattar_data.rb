# frozen_string_literal: true

require 'base64'

class CatchAwattarData < Actor
  input :starts_at
  input :ends_at, default: Time.zone.now

  def call
    puts awattar_data.inspect

    awattar_data['data'].each do |awattar_record|
      starts_at = Time.zone.at(awattar_record['start_timestamp'] / 1000).strftime('%Y-%m-%d %H:%M:%S')
      ends_at = Time.zone.at(awattar_record['end_timestamp'] / 1000).strftime('%Y-%m-%d %H:%M:%S')
      value = awattar_record['marketprice'] * 100 / 1000 # original is EUR/MWh
      # puts starts_at
      # puts ends_at
      # puts value

      EpexDataRecord.create!(unit: 'ct/kWh',
                             value:,
                             starts_at:,
                             ends_at:,
                             source: 'awattar')
    end
  end

  private

  def make_base_auth(t, e)
      "Basic " + Base64.strict_encode64(t + ":" + e)
  end

  def awattar_data
    @awattar_data ||= AwattarService.fetch(starts_at, ends_at)
  end
end
