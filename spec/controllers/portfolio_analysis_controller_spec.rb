require "rails_helper"

RSpec.describe PortfolioAnalysisController, :type => :controller do

  describe '#future_value' do
    it 'assigns the PortfolioAnalysers for each scenario' do
      get :future_value
      expect(assigns(:portfolio_analysis_1)).to be_a(PortfolioAnalyser)
      expect(assigns(:portfolio_analysis_2)).to be_a(PortfolioAnalyser)
    end

    context 'when chart is selected as the view' do
      it 'renders the chart view' do
        get :future_value, {view: 'chart'}
        expect(subject).to render_template('future_value_chart')
      end
    end

    context 'when table is selected as the view' do
      it 'renders the table view' do
        get :future_value, {view: 'table'}
        expect(subject).to render_template('future_value')
      end
    end

  end
end
