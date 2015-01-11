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

  describe 'filtered_accounts' do
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

    context 'when no parameters are given' do
      it 'finds accounts based on the filters' do
        expect(Account.filtered_accounts({}).size).to eq(2)
      end
    end

    context 'when retirement accounts only is specified' do
      it 'returns only retirement accounts' do
        expect(Account.filtered_accounts( {:retirement => 'retirement_only'})).to eq([@account_1])
      end
    end

    context 'when the account owner is specified' do
      it 'returns only history for owners of that account' do
        params = {:account_owner_id => @account_owner_1.id}
        accounts  = Account.filtered_accounts(params)
        expect(accounts).to eq([@account_1])
      end
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

  describe '.breakdown' do
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
      Account.build_and_save_account({name: 'Test3', value: '300', account_type_id: @account_type_1.id, account_owner_id: @account_owner_1.id})
    end

    context 'when account is selected' do
      it 'returns totals by account' do
        expect(Account.breakdown('account')).to eq( [["Test", 100], ["Test2", 200], ["Test3", 300]] )
      end
    end

    context 'when retirement status is selected' do
      it 'returns totals by retirement status' do
        expect(Account.breakdown('retirement')).to eq( [["retirement", 400], ["non-retirement", 200]] )
      end
    end

    context 'when account type is selected' do
      it 'returns totals by account type' do
        expect(Account.breakdown('type')).to eq( [[@account_type_1.description, 400], [@account_type_2.description, 200]] )
      end
    end

    context 'when retirement status is selected' do
      it 'returns totals by owner' do
        expect(Account.breakdown('owner')).to eq( [["Joe", 400], ["Joe and Mary", 200]] )
      end
    end
  end
end