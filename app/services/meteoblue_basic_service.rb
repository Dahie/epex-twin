# frozen_string_literal: true

class MeteoblueBasicService
  def self.fetch
    # covers next 7 days from now
    url = "http://my.meteoblue.com/packages/basic-1h_basic-day?lat=48.128&lon=16.22&apikey=#{ENV.fetch('METEOBLUE_API_TOKEN', nil)}"

    JSON.parse(HTTP.get(url).to_s)
  end
end
