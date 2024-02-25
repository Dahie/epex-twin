# frozen_string_literal: true

class CatchGeosphereData < Actor
  input :starts_at
  input :ends_at, default: Time.zone.today

  def call
    (0..23).each do |hour|
      starts_at = Time.zone.parse(geosphere_data['timestamps'][hour])
      ends_at = Time.zone.parse(geosphere_data['timestamps'][hour + 1])
      value = geosphere_data['features'][0]['properties']['parameters']['cglo']['data'][hour]
      unit = geosphere_data['features'][0]['properties']['parameters']['cglo']['unit']

      GeosphereGlobalRadiationRecord.create!(unit:,
                                             value:,
                                             starts_at:,
                                             ends_at:,
                                             source: 'geosphere')

      value = geosphere_data['features'][0]['properties']['parameters']['ff']['data'][hour]
      unit = geosphere_data['features'][0]['properties']['parameters']['ff']['unit']

      GeosphereWindRecord.create!(unit:,
                                  value:,
                                  starts_at:,
                                  ends_at:,
                                  source: 'geosphere')
    end
  end

  private

  def geosphere_data
    @geosphere_data ||= HTTParty.get("https://dataset.api.hub.geosphere.at/v1/station/historical/klima-v2-1h?parameters=FF,cglo&station_ids=5935&start=#{starts_at.strftime('%Y-%m-%dT%H:%M')}&end=#{ends_at.strftime('%Y-%m-%dT%H:%M')}")
  end
end
