class PortfolioAnalysisController < ApplicationController
  include Common

  def future_value
    @portfolio_analysis = PortfolioAnalyser.new(params)
    if params[:view] == 'chart'
      render "future_value_chart"
    end
  end

  private

  def future_value_params
    params.require(:account).permit(:name, :value, :date_opened, :account_type_id, :account_owner_id)
  end

end