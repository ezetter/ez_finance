class PortfolioAnalysisController < ApplicationController
  include Common

  def future_value
    init_account_category_selects

    @accounts = Account.filtered_accounts(params).sort.map { |acc| [acc.name, acc.id] }
    @portfolio_analysis_1 = PortfolioAnalyser.new(portfolio_analysis_params(1))
    @portfolio_analysis_2 = PortfolioAnalyser.new(portfolio_analysis_params(2))
    if params[:view] == 'chart'
      render "future_value_chart"
    end
  end

  def breakdown
    @slices = Account.breakdown(params[:view])
  end

  private

  def portfolio_analysis_params(scenario_num)
    attributes = params
    attributes[:rate] = params["rate_#{scenario_num}"]
    attributes[:payment] = params["payment_#{scenario_num}"]
    attributes[:periods] = params[:periods]
    attributes
  end

end