class PortfolioAnalyser
  include ActiveModel::Model

  attr_accessor :present_value, :rate, :payment, :periods, :annual_future_value

  def initialize(attributes={})
    attributes[:rate] ||= 0.07
    attributes[:payment] ||= 0.00
    attributes[:periods] ||= 30

    @rate = attributes[:rate].to_f
    @payment = attributes[:payment].to_f
    @periods = attributes[:periods].to_i
    @annual_future_value = calc_annual_future_value(attributes)
  end

  def future_value_values
    @annual_future_value.map{|d| d[:value].round}
  end

  def future_value_years
    @annual_future_value.map{|d| d[:date].strftime("%Y").to_i}
  end

  private

  def calc_annual_future_value(params)
    @present_value ||= Account.filtered_accounts(params).inject(0) { |sum, acct| sum + acct.value}
    fv_ann = []
    (0..periods).each do |i|
      g = Math.exp(i * rate)
      fv = @present_value * g + payment/(Math.exp(rate) -1) * (g - 1)
      fv_ann << {year: i, date: Time.now + i.years, value: fv}
    end

    fv_ann
  end

end
