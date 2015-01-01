require "rails_helper"

RSpec.describe Account, :type => :model do
  before :each do
    DatabaseCleaner.clean
  end

  describe '#destroy' do
    it 'destroy deletes the associated history' do
      account = Account.new(name: 'Test', value: 100, value_fractional: 0)
      account.save
      expect(AccountHistory.count).to eq(1)
      account.destroy
      expect(AccountHistory.count).to eq(0)
    end
  end

  describe '.build_account' do
    it 'updates the account if account passed as argument' do
      account = Account.build_and_save_account({name: 'Test', value: '100'})
      expect(Account.first.value).to eq(100)
      Account.build_and_save_account({name: 'Test', value: '200'}, account)
      expect(Account.first.value).to eq(200)
    end

    it 'changes updated date if updating' do
      account = nil
      Timecop.freeze(Time.local(2014, 10, 1, 12, 0, 0)) do
        account = Account.build_and_save_account({name: 'Test', value: '100'})
      end
      expect(Account.first.updated).to eq(DateTime.new(2014,10,1))
      Timecop.freeze(Time.local(2014, 10, 2, 12, 0, 0)) do
        account = Account.build_and_save_account({name: 'Test', value: '200'}, account)
      end
      expect(Account.first.updated).to eq(DateTime.new(2014,10,2))
    end

    it 'creates a new Account' do
      account = Account.build_and_save_account({name: 'Test', value: '100'})
      expect(Account.all).to eq([account])
    end

    it 'assigns the account owner' do
      account_owner = create(:account_owner)
      Account.build_and_save_account({name: 'Test', value: '100', account_owner: account_owner})
      expect(Account.first.account_owner).to eq(account_owner)
    end
  end

  describe '#displayed_value' do
    context 'when value is not yet assigned' do
      it 'returns 0.00' do
        expect(Account.new.displayed_value).to eq('0.00')
      end
    end

    context 'when fractional_value is not assigned' do
      it 'returns the value formatted x.00' do
        account = Account.new
        account.value = 100
        expect(account.displayed_value).to eq('100.00')
      end
    end

    context 'when value is not assigned' do
      it 'returns the value formatted 0.xx' do
        account = Account.new
        account.value_fractional = 50
        expect(account.displayed_value).to eq('0.50')
      end
    end

    context 'when value is assigned' do
      it 'returns the value formatted x.xx' do
        account = Account.new
        account.value = 100
        account.value_fractional = 50
        expect(account.displayed_value).to eq('100.50')
      end
    end
  end
end