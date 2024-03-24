# frozen_string_literal: true

class CatchMeteoblueBasicData < Actor
  def call
    windspeeds = data.dig('data_1h', 'windspeed')
    times = data.dig('data_1h', 'time')
    temperatures = data.dig('data_1h', 'temperature')

    times.each_with_index do |datetime, index|
      starts_at = Time.zone.parse(datetime).strftime('%Y-%m-%d %H:%M:%S')
      ends_at = (Time.zone.parse(datetime) + 1.hour).strftime('%Y-%m-%d %H:%M:%S')

      record = MeteoblueWindForecastRecord.find_or_create_by(starts_at:, ends_at:)
      record.update(unit: 'm/s', value: windspeeds[index], source: 'meteoblue')

      record = MeteoblueTemperatureForecastRecord.find_or_create_by(starts_at:, ends_at:)
      record.update(unit: '°C', value: temperatures[index], source: 'meteoblue')
    end
  end

  private

  def data
    @data ||= MeteoblueBasicService.fetch
  end
end
