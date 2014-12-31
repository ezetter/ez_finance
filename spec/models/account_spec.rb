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
end