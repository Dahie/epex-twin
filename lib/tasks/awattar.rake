# frozen_string_literal: true

namespace :awattar do
  desc 'Fetch all daily records since Jan 2019'
  task fetch_historic: [:environment] do
    start_date = Date.new(2019, 7, 1)
    CatchAwattarData.call(starts_at: start_date)
  end
end
