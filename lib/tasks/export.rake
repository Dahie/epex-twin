# frozen_string_literal: true

require 'csv'

namespace :epex_twin do
  desc 'Export all records to csv'
  task export: [:environment] do
    output_string = CSV.generate do |csv|
      csv << %w[ds y radiation wind]
      DataRecord.select(:starts_at).group(:starts_at).map(&:starts_at).each do |start_time|
        records = DataRecord.where(starts_at: start_time)

        price = records.find { |r| r.is_a?(EpexDataRecord) }
        wind = records.find { |r| r.is_a?(GeosphereWindRecord) }
        radiation = records.find { |r| r.is_a?(GeosphereGlobalRadiationRecord) }

        puts price
        puts wind
        puts radiation

        next unless price && wind && radiation

        csv << [start_time.strftime("%Y-%m-%d %H:%M:%S"), price.value, wind.value, radiation.value]
      end
    end
    File.write("data.csv", output_string)
  end

  desc 'Migrate data to production'
  task migrate: [:environment] do
    url = "https://epex-twin-production.fly.dev/api/v1/data"
    DataRecord.find_each do |data_record|
      attributes = data_record.attributes

      response = HTTP.auth("Bearer #{ENV.fetch('EPEX_TWIN_API_TOKEN', nil)}")
             .post(url, json: { data: attributes }.to_json)
      puts response
      sleep 0.1
    end
  end
end
