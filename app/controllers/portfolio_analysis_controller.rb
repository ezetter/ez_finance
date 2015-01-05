class PortfolioAnalysisController < ApplicationController
  include Common

  def future_value
    @portfolio_analysis_1 = PortfolioAnalyser.new(portfolio_analysis_params(1))
    @portfolio_analysis_2 = PortfolioAnalyser.new(portfolio_analysis_params(2))
    if params[:view] == 'chart'
      render "future_value_chart"
    end
  end

  private

  def portfolio_analysis_params(scenario_num)
    attributes = {}
    attributes[:rate] = params["rate_#{scenario_num}"]
    attributes[:payment] = params["payment_#{scenario_num}"]
    attributes[:periods] = params[:periods]
    attributes
  end

end