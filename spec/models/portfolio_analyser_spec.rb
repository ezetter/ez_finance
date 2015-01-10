require "rails_helper"

RSpec.describe PortfolioAnalyser, :type => :model do
  before :each do
    DatabaseCleaner.clean
  end

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

    context 'when filters are used' do

      before do
        Rails.application.load_seed
        @account_type_1 = AccountType.where('retirement = true')[0]
        @account_type_2 = AccountType.where('retirement = false')[0]
        @account_owner_1 = AccountOwner.new(name: 'Joe', joint: 'false')
        @account_owner_1.save
        account_owner_2 = AccountOwner.new(name: 'Joe and Mary', joint: 'true')
        account_owner_2.save
        @account_1 = Account.build_and_save_account({name: 'Test', value: '100', account_type_id: @account_type_1.id, account_owner_id: @account_owner_1.id})
        Account.build_and_save_account({name: 'Test2', value: '200', account_type_id: @account_type_2.id, account_owner_id: account_owner_2.id})
      end

      context 'when filtered by retirement only' do
        it 'returns values only for retirement accounts' do
          attributes = {:rate => '0.08', :payment => '100', :periods => '5', :retirement => 'retirement_only'}
          analyser = PortfolioAnalyser.new(attributes)
          expect(analyser.annual_future_value[0][:value].round(2)).to eq(100)
        end
      end

      context 'when filter by a specific account' do
        it 'returns values only for that account' do
          attributes = {:rate => '0.08', :payment => '100', :periods => '5', :account_id => "#{@account_1.id}"}
          analyser = PortfolioAnalyser.new(attributes)
          expect(analyser.annual_future_value[0][:value].round(2)).to eq(100)
        end
      end

    end
  end
end
