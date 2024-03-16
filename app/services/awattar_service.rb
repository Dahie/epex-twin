class AwattarService
  def self.fetch(starts_at, ends_at)
    start_at_timestamp = starts_at.to_time.to_i * 1000 # awattar takes and gives epoch in miliseconds
    ends_at_timestamp = ends_at&.to_time&.to_i&.* 1000

    # HTTParty.get("https://api.awattar.at/v1/marketdata?start=#{start_at_timestamp}&end=#{ends_at_timestamp}")

    url = "https://api.awattar.at/v1/marketdata?start=#{start_at_timestamp}&end=#{ends_at_timestamp}"

    HTTParty.get(url, headers: { 'Authorization' => make_base_auth("tok_PgkhUFtdFwJQ9ARugDqJBgPitvKPD9Gt", "") })
  end
end
