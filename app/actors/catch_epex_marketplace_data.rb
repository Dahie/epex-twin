# frozen_string_literal: true

class CatchEpexMarketplaceData < Actor
  def call
    epex_marketplace_data.each do |market_record|
      record = EpexSpotPriceRecord.find_or_create_by(
        starts_at: market_record[:starts_at],
        ends_at: market_record[:ends_at]
)
      record.update(source: 'epex_marketplace',
                    value: market_record[:value],
                    unit: 'ct/kWh')
    end
  end

  private

  def epex_marketplace_data
    @epex_marketplace_data ||= EpexMarketplaceService.new.fetch
  end
end
