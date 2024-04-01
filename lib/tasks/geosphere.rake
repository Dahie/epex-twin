# frozen_string_literal: true

namespace :geosphere do
  desc 'Fetch all daily records since July 2019'
  task fetch_historic: [:environment] do
    start_date = GeosphereWindRecord.order(:starts_at).last.starts_at.to_date || Date.new(2024, 3, 20)
    end_date = Time.zone.today

    (start_date..end_date).each do |date|
      CatchGeosphereData.call(starts_at: date)
      sleep 1
    end
  end
end
