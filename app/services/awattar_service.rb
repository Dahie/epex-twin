# frozen_string_literal: true

class AwattarService
  def self.fetch(starts_at, ends_at)
    start_at_timestamp = starts_at.to_time.to_i * 1000 # awattar takes and gives epoch in miliseconds
    ends_at_timestamp = ends_at&.to_time&.to_i&.* 1000

    url = "https://api.awattar.at/v1/marketdata?start=#{start_at_timestamp}&end=#{ends_at_timestamp}"

    JSON.parse(HTTP.get(url).to_s)
  end
end
