# frozen_string_literal: true

namespace :geosphere do
  desc 'Fetch all daily records since July 2019'
  task fetch_historic: [:environment] do
    Date.new(2019, 7, 1)
    start_date = Date.new(2024, 2, 23)
    end_date = Time.zone.zone.today

    (start_date..end_date).each do |date|
      CatchGeosphereData.call(starts_at: date + 1.day)
      sleep 1
    end
  end
end
