# frozen_string_literal: true

class CatchMeteoblueBasicData < Actor
  def call
    windspeeds = data.dig('data_1h', 'windspeed')
    times = data.dig('data_1h', 'time')

    times.each_with_index do |datetime, index|
      starts_at = Time.zone.parse(datetime).strftime('%Y-%m-%d %H:%M:%S')
      ends_at = (Time.zone.parse(datetime) + 1.hour).strftime('%Y-%m-%d %H:%M:%S')
      value = windspeeds[index]
      begin
        MeteoblueWindForecastRecord.create(unit: 'm/s',
                                           value:,
                                           starts_at:,
                                           ends_at:,
                                           source: 'meteoblue')
      rescue StandardError => e
        Rails.logger.debug e.inspect
      end
    end
  end

  private

  def data
    @awattar_data ||= MeteoblueBasicService.fetch
  end
end
