require "rails_helper"

RSpec.describe Account, :type => :model do
  before :each do
    DatabaseCleaner.clean
  end

  describe '#create' do
    it 'creates the account' do
      account = Account.create!(name: 'Big Bank', value: 1000)
      expect(Account.all).to eq([account])
    end
  end

  describe '#destroy' do
    it 'destroy deletes the associated history' do
      account = Account.new(name: 'Test', value: 100, value_fractional: 0)
      account.save
      AccountHistory.save_history(account)
      expect(AccountHistory.count).to eq(1)
      account.destroy
      expect(AccountHistory.count).to eq(0)
    end
  end
end