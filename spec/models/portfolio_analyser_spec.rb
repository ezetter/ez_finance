require "rails_helper"

RSpec.describe PortfolioAnalyser, :type => :model do

  describe '#initialize' do
    it 'assigns attributes' do
      attributes = {:rate => '0.08', :payment => '100', :periods => '5'}
      analyser = PortfolioAnalyser.new(attributes)
      expect(analyser.rate).to eq(0.08)
      expect(analyser.payment).to eq(100)
      expect(analyser.periods).to eq(5)
    end

    it 'defaults rate to 0.07' do
      attributes = {}
      analyser = PortfolioAnalyser.new(attributes)
      expect(analyser.rate).to eq(0.07)
    end

    it 'defaults payment to 0' do
      attributes = {}
      analyser = PortfolioAnalyser.new(attributes)
      expect(analyser.payment).to eq(0)
    end

    it 'defaults periods to 30' do
      attributes = {}
      analyser = PortfolioAnalyser.new(attributes)
      expect(analyser.periods).to eq(30)
    end
  end

  describe '#annual_future_value' do

    it 'generates the periods plus one for present value' do
      attributes = {:rate => '0.08', :payment => '100', :periods => '5'}
      analyser = PortfolioAnalyser.new(attributes)
      expect(analyser.annual_future_value.size).to eq(6)
    end

    it 'calculates the future value' do
      Account.build_and_save_account({name: 'Test', value: '100'})
      attributes = {:rate => '0.08', :payment => '100', :periods => '5'}
      analyser = PortfolioAnalyser.new(attributes)
      expect(analyser.annual_future_value[5][:value].round(2)).to eq(739.70)
    end
  end
end
