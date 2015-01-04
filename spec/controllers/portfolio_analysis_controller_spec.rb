require "rails_helper"

RSpec.describe PortfolioAnalysisController, :type => :controller do

  describe '#future_value' do
    it 'assigns the analysis model with future value results' do
      get :future_value
      expect(assigns(:portfolio_analysis)).to be_a(PortfolioAnalyser)
    end
  end
end
