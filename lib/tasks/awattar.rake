# frozen_string_literal: true

namespace :awattar do
  desc 'Fetch all daily records since Jan 2019'
  task fetch_historic: [:environment] do
    start_date = (AwattarSpotPriceRecord.order(:starts_at).last.starts_at + 1.hour) || Date.new(2024, 3, 23)
    CatchAwattarData.call(starts_at: start_date)
  end
end
