# frozen_string_literal: true

every 2.hours do
  runner "EpexSpotAtHourlyBot.new.perform"
end

every 1.day, at: '1:05 pm' do
  runner "CatchEpexMarketplaceData.new.perform"
end

# Learn more: http://github.com/javan/whenever
