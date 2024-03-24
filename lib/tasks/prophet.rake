# frozen_string_literal: true

require 'csv'

namespace :prophet do
  desc 'Forcast 7 days'
  task forecast: [:environment] do
    data = [].tap do |data|
      DataRecord.order(starts_at: :asc).select(:starts_at).group(:starts_at).map(&:starts_at).each do |start_time|
        # where("starts_at < ?", 7.days.ago).
        next unless start_time < 7.days.ago

        records = DataRecord.where(starts_at: start_time)

        price = records.find { |r| r.is_a?(EpexDataRecord) }
        wind = records.find { |r| r.is_a?(GeosphereWindRecord) }
        radiation = records.find { |r| r.is_a?(GeosphereGlobalRadiationRecord) }

        next unless price && wind && radiation

        data << { "ds" => start_time.strftime("%Y-%m-%d %H:%M:%S"),
          "y" => price.value,
          "wind" => wind.value }
        # "radiation" => radiation.value }
      end
    end

    puts data.count

    df = Rover::DataFrame.new(data)
    df['cap'] = 100.0
    df['floor'] = 0.0
    puts df.tail

    model = Prophet.new(growth: 'logistic')
    model.add_regressor('wind')
    # model.add_regressor('radiation')
    # model.add_regressor('temperature')
    model.fit(df)

    periods_to_predict = 24 * 7
    future = model.make_future_dataframe(periods: periods_to_predict, freq: "H")

    wind = lambda do |ds|
      (GeosphereWindRecord.find_at_starts_at(ds) || MeteoblueWindForecastRecord.find_at_starts_at(ds) )&.value || 0.0
    end

    future["cap"] = 100.0
    future["floor"] = 0.0
    future["wind"] = future["ds"].map(&wind)

    puts future.tail(periods_to_predict)

    forecast = model.predict(future)
    puts forecast[["ds", "yhat", "yhat_lower", "yhat_upper"]].tail(periods_to_predict + 24)

    forecast[["ds", 'yhat']].tail(periods_to_predict).to_a.each do |_row|
      record = EpexSpotForecastRecord.find_or_create_by(starts_at: _row['ds'].round(2),
                                                        ends_at: _row['ds'] + 1.hour)
      record.update(unit: "ct/kWh",
                    source: 'prophet',
                    value: _row['yhat'])
    end

    # m.plot(forecast).savefig("forecast.png")
  end
end
