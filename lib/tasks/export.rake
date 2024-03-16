# frozen_string_literal: true

namespace :epex_twin do
  desc 'Export all records to csv'
  task export: [:environment] do
    output_string = CSV.generate do |csv|
      csv << %w[starts_at ends_at price radiation wind]
      DataRecord.select(:starts_at).group(:starts_at).map(&:starts_at).each do |start_time|
        records = DataRecord.where(starts_at: start_time)

        price = records.find { |r| r.is_a?(EpexDataRecord) }
        wind = records.find { |r| r.is_a?(GeosphereWindRecord) }
        radiation = records.find { |r| r.is_a?(GeosphereGlobalRadiationRecord) }

        puts price
        puts wind
        puts radiation

        next unless price && wind && radiation

        csv << [start_time.strftime("%Y-%m-%d-%H-%M"), price.value, wind.value, radiation.value]
      end
    end
    File.write("data.csv", output_string)
  end
end
