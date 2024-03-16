# frozen_string_literal: true

class CatchEpexMarketplaceData < Actor
  def call
    epex_marketplace_data.each do |market_record|
      EpexDataRecord.create!(unit: 'ct/kWh',
                             value: market_record[:value],
                             starts_at: market_record[:starts_at],
                             ends_at: market_record[:ends_at],
                             source: 'epex_marketplace')
    end
  end

  private

  def epex_marketplace_data
    @epex_marketplace_data ||= EpexMarketplaceService.new.fetch
  end
end
