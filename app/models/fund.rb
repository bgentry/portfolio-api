require 'yahoo_finance'

class Fund < Sequel::Model
  many_to_one :asset_class
  one_to_many :lots

  validates :asset_class, :name, :symbol, :expense_ratio, presence: true

  dataset_module do
    # Not safe to harvest losses of these funds:
    def recently_purchased
      where(id: recently_purchased_fund_ids)
    end

    def recently_purchased_fund_ids
      Lot.recently_purchased.distinct(:fund_id).select(:fund_id)
    end

    def recently_sold
      where(id: recently_sold_fund_ids)
    end

    def recently_sold_fund_ids
      Lot.recently_sold.distinct(:fund_id).select(:fund_id)
    end

    # Not safe to buy funds in this group:
    def recently_realized_losses
      where(id: recently_realized_losses_fund_ids)
    end

    def recently_realized_losses_fund_ids
      Lot.recently_sold.losses.distinct(:fund_id).select(:fund_id)
    end

    def safe_to_buy
      exclude(id: recently_realized_losses_fund_ids)
    end

    def safe_to_harvest_losses
      exclude(id: recently_purchased_fund_ids)
    end
  end

  def self.update_all_prices
    funds = Fund.all
    price_data = YahooFinance.quotes(funds.map(&:symbol), [:symbol, :last_trade_price, :last_trade_date, :last_trade_time])
    funds.each do |fund|
      data = price_data.find {|d| d.symbol == fund.symbol}
      unless data
        Rails.log.debug("symbol=#{fund.symbol} error=price_data_not_found")
        next
      end
      fund.raise_on_save_failure = true
      # TODO: calculate time based on actual parsed quote data
      fund.update(price: data.last_trade_price, price_updated_at: 15.minutes.ago)
    end
  end

  def update_price
    price_data = YahooFinance.quotes([self.symbol], [:symbol, :last_trade_price, :last_trade_date, :last_trade_time]).first
    self.raise_on_save_failure = true
    # TODO: calculate time based on actual parsed quote data
    self.update(price: price_data.last_trade_price, price_updated_at: 15.minutes.ago)
  end
end
