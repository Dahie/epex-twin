# frozen_string_literal: true

# https://www.epexspot.com/en/market-data?market_area=AT&trading_date=2024-03-08&delivery_date=2024-03-09&underlying_year=&modality=Auction&sub_modality=DayAhead&technology=&product=60&data_mode=table&period=&production_period=

class EpexMarketplaceService
  def fetch
    doc = Nokogiri::HTML(html_body)
    xpath = "//table[@data-head='#{delivery_date.strftime('%d.%m.%y')}']"
    convert_table_to_hash(doc.at_xpath(xpath))
  end

  private

  def trading_date
    Time.zone.today
  end

  def delivery_date
    (Time.zone.today + 1)
  end

  def url
    @url ||= "https://www.epexspot.com/en/market-data?market_area=AT&trading_date=#{trading_date.strftime('%Y-%m-%d')}&delivery_date=#{delivery_date.strftime('%Y-%m-%d')}&modality=Auction&sub_modality=DayAhead&technology=&product=60&data_mode=table"
  end

  def html_body
    @html_body ||= HTTP.get(url).to_s
  end

  def convert_table_to_hash(table)
    table_data = []

    table.search('tr').each do |row|
      row_data = row.search('th, td').map do |cell|
        cell.text.strip
      end
      table_data << row_data unless row_data.empty?
    end

    table_data.last(24).map.with_index do |row, index|
      price = row[3].to_f * 100 / 1000 # original is EUR/MWh
      starts_at = "#{delivery_date} #{index.to_s.rjust(2, '0')}:00"
      ends_at = "#{delivery_date} #{(index + 1).to_s.rjust(2, '0')}:00"
      {
        starts_at: DateTime.parse(starts_at),
        ends_at: DateTime.parse(ends_at),
        value: price
      }
    end
  end
end
