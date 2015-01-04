class PortfolioAnalysisController < ApplicationController
  include Common

  def future_value
    @portfolio_analysis = PortfolioAnalyser.new(params)
  end

  def future_value_params
    params.require(:account).permit(:name, :value, :date_opened, :account_type_id, :account_owner_id)
  end

end