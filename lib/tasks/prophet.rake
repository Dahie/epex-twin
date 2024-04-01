# frozen_string_literal: true

require 'csv'

namespace :prophet do
  desc 'Forcast 7 days'
  task forecast: [:environment] do
    service = ForecastService.new
    # service.forecast
    service.persist
  end
end
