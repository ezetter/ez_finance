require "rails_helper"

feature 'User views account history' do
  before :each do
    DatabaseCleaner.clean
    Rails.application.load_seed
    account_type_1 = AccountType.where('retirement = true')[0]
    account_type_2 = AccountType.where("description = 'Brokerage'")[0]
    account_owner_1 = AccountOwner.new(name: 'Joe', joint: 'false')
    account_owner_1.save
    account_owner_2 = AccountOwner.new(name: 'Joe and Mary', joint: 'true')
    account_owner_2.save
    Timecop.freeze(Time.local(2014, 10, 1, 12, 0, 0)) do
      Account.build_and_save_account({name: 'Test Account', value: '100', account_type_id: account_type_1.id, account_owner_id: account_owner_1.id})
      Account.build_and_save_account({name: 'Test Account2', value: '200', account_type_id: account_type_2.id, account_owner_id: account_owner_2.id})
    end
    Timecop.freeze(Time.local(2014, 10, 5, 12, 0, 0)) do
      account = Account.first
      Account.build_and_save_account({name: 'Test Account', value: '500', account_type_id: account_type_1.id, account_owner_id: account_owner_1.id}, account)
    end

  end

  scenario 'user navigates to the Account History page' do
    visit account_history_index_path
    expect(page).to have_title("EZ Finance | Account History")
  end

  scenario 'user submits with defaults' do
    Timecop.freeze(Time.local(2014, 10, 10, 12, 0, 0)) do
      visit account_history_index_path
      click_button 'View History'
      content = page.body.gsub(/\s/,'')
      expect(content).to include('2014-10-01</td><td>$300.00')
      expect(content).to include('2014-10-04</td><td>$300.00')
      expect(content).to include('2014-10-05</td><td>$700.00')
      expect(content).to include('2014-10-06</td><td>$700.00')
    end
  end

  scenario 'user selects an account then submits' do
    Timecop.freeze(Time.local(2014, 10, 10, 12, 0, 0)) do
      visit account_history_index_path
      select('Test Account')
      click_button 'View History'
      content = page.body.gsub(/\s/,'')
      expect(content).to include('2014-10-01</td><td>$100.00')
    end
  end

  scenario 'user selects an account type then submits' do
    Timecop.freeze(Time.local(2014, 10, 10, 12, 0, 0)) do
      visit account_history_index_path
      select('Brokerage')
      click_button 'View History'
      content = page.body.gsub(/\s/,'')
      expect(content).to include('2014-10-01</td><td>$200.00')
    end
  end

  scenario 'user selects an retirement then submits' do
    Timecop.freeze(Time.local(2014, 10, 10, 12, 0, 0)) do
      visit account_history_index_path
      select('Retirement Only')
      click_button 'View History'
      content = page.body.gsub(/\s/,'')
      expect(content).to include('2014-10-01</td><td>$100.00')
    end
  end

  scenario 'user selects multiple options then submits' do
    Timecop.freeze(Time.local(2014, 10, 10, 12, 0, 0)) do
      visit account_history_index_path
      select('Brokerage')
      select('Retirement Only')
      click_button 'View History'
      content = page.body.gsub(/\s/,'')
      expect(content).to include('2014-10-01</td><td>$0.00')
    end
  end

end