# frozen_string_literal: true

class EpexSpotAtHourlyBot < Bot
  def initialize
    super(ENV.fetch("MASTODON_URL", nil), ENV.fetch("ACCESS_TOKEN_EPEX_TWIN_AT", nil))
  end

  def perform
    post_message(message)
  end

  def message
    "EPEX Strompreis Österreich\n" \
      "#{time_slot_now}: #{value_with_unit_now}\n" \
      "#{time_slot_next}: #{value_with_unit_next}"
  end

  private

  def current_hour
    Time.zone.now.hour
  end

  def time_slot_now
    "#{current_hour}-#{current_hour + 1} Uhr"
  end

  def time_slot_next
    "#{current_hour + 1}-#{current_hour + 2} Uhr"
  end

  def value_with_unit_now
    data_record_now.value_with_unit.to_s
  end

  def value_with_unit_next
    "#{data_record_next.value_with_unit} #{tendency_emoji}"
  end

  def tendency_emoji
    return "" if data_record_now.value == data_record_next.value

    data_record_now.value < data_record_next.value ? "↗️" : "↘️"
  end

  def data_record_now
    @data_record_now ||= find_data_record(Time.zone.now.strftime('%Y-%m-%d %H:00:00.000'))
  end

  def data_record_next
      @data_record_next ||= find_data_record(1.hour.from_now.strftime('%Y-%m-%d %H:00:00.000'))
  end

  def find_data_record(starts_at)
    DataRecord.find_by(source: ['epex_marketplace', 'awattar'], starts_at: )
  end
end
