require "rails_helper"

RSpec.describe Account, :type => :model do
  before :each do
    DatabaseCleaner.clean
  end

  describe '.get_history' do
    before :each do
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

    context 'when no parameters are passed' do
      it 'returns all history' do
        history = AccountHistory.get_history
        expect(history.size).to eq(2)
      end
    end

    context 'when the account is specified' do
      it 'returns only history for that account' do
        params = {:account_id => @account_1.id}
        history = AccountHistory.get_history(params)
        expect(history.size).to eq(1)
        expect(history[0].account.id).to eq(@account_1.id)
      end
    end

    context 'when the account owner is specified' do
      it 'returns only history for owners of that account' do
        params = {:account_owner_id => @account_owner_1.id}
        history = AccountHistory.get_history(params)
        expect(history.size).to eq(1)
        expect(history[0].account).to eq(@account_1)
      end
    end

    context 'when non-retirement accounts only is specified' do
      it 'returns only non-retirement accounts' do
        params = {:retirement => 'non_retirement_only'}
        history = AccountHistory.get_history(params)
        expect(history.size).to eq(1)
        expect(history[0].account.account_type).to eq(@account_type_2)
      end
    end

    context 'when retirement accounts only is specified' do
      it 'returns only retirement accounts' do
        params = {:retirement => 'retirement_only'}
        history = AccountHistory.get_history(params)
        expect(history.size).to eq(1)
        expect(history[0].account.account_type).to eq(@account_type_1)
      end
    end
  end

  describe '.get_intervals' do
    before :each do
      @account_histories = []
      account1 = Account.new
      account2 = Account.new
      (2..10).each do |i|
        @account_histories << AccountHistory.new(date_changed: Time.now - i.days, historical_value: 100, account: account1)
        @account_histories << AccountHistory.new(date_changed: Time.now - i.days, historical_value: 200, account: account2)
      end
      @account_histories << AccountHistory.new(date_changed: Time.now - 1.day, historical_value: 200, account: account1)
      @account_histories << AccountHistory.new(date_changed: Time.now - 1.day, historical_value: 300, account: account2)
    end

    it 'gets the specified number of intervals' do
      histories = AccountHistory.get_intervals(@account_histories, 5, 1)
      expect(histories.size).to eq(5)
    end

    it 'gets the total value from the end of each interval' do
      histories = AccountHistory.get_intervals(@account_histories, 5, 2)
      expect(histories[0][1]).to eq(500)
      expect(histories[1][1]).to eq(300)
    end
  end

end