# frozen_string_literal: true

class ForecastService
  PERIODS_TO_PREDICT = 24 * 7

  def prediction
    @prediction ||= model.predict
  end

  def forecast
    # puts prediction[["ds", "yhat", "yhat_lower", "yhat_upper"]].tail(PERIODS_TO_PREDICT + 24)
    @forecast ||= prediction[["ds", 'yhat']].tail(PERIODS_TO_PREDICT).to_a
  end

  def persist
    forecast.map do |row|
      record = EpexSpotForecastRecord.find_or_create_by(starts_at: row['ds'],
                                                        ends_at: row['ds'] + 1.hour)
      record.update(unit: "ct/kWh",
                    source: 'prophet',
                    value: row['yhat'].round(2))
    end
  end

  private

  def model
    return @model if @model

    @model = Prophet.new # (growth: 'logistic')
    @model.add_regressor('wind')
    # model.add_regressor('radiation')
    @model.add_regressor('temperature')
    @model.fit(training_data_frame)
    @model
  end

  def build_future_df
    wind = lambda do |ds|
      (GeosphereWindRecord.find_at_starts_at(ds) || MeteoblueWindForecastRecord.find_at_starts_at(ds) )&.value || 0.0
    end
    temperature = lambda do |ds|
      GeosphereTemperatureRecord.find_at_starts_at(ds)&.value || 0.0
    end

    future = model.make_future_dataframe(periods: PERIODS_TO_PREDICT, freq: "H")
    future["cap"] = 100.0
    future["floor"] = 0.0
    future["wind"] = future["ds"].map(&wind)
    future["temperature"] = future["ds"].map(&temperature)

    Rails.logger.debug future.tail(PERIODS_TO_PREDICT)
  end

  def training_data_frame
    df = Rover::DataFrame.new(training_data)
    df['cap'] = 100.0
    df['floor'] = 0.0

    Rails.logger.debug df.tail

    df
  end

  def grouped_starts_at
    DataRecord.order(starts_at: :asc).select(:starts_at).group(:starts_at).map(&:starts_at)
  end

  def training_data
    [].tap do |data|
      grouped_starts_at.each do |start_time|
        # where("starts_at < ?", 7.days.ago).
        next unless start_time > 7.months.ago

        records = DataRecord.where(starts_at: start_time)

        price = records.find { |r| r.is_a?(AwattarSpotPriceRecord) }
        wind = records.find { |r| r.is_a?(GeosphereWindRecord) }
        radiation = records.find { |r| r.is_a?(GeosphereGlobalRadiationRecord) }
        temperature = records.find { |r| r.is_a?(GeosphereTemperatureRecord) }

        next unless price && wind && radiation && temperature

        data << { "ds" => start_time.strftime("%Y-%m-%d %H:%M:%S"),
          "y" => price.value,
          "temperature" => temperature.value,
          "wind" => wind.value }
        # "radiation" => radiation.value }
      end
    end
  end
end
