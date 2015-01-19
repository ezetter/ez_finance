require "rails_helper"

feature 'Non admin user attempts to perform admin actions' do
  include Warden::Test::Helpers
  Warden.test_mode!

  before :each do
    DatabaseCleaner.clean
    Rails.application.load_seed
    user = FactoryGirl.create(:user)
    login_as(user, :scope => :user, :run_callbacks => false)
  end

  scenario 'they try to create an account' do
    account_owner_1 = AccountOwner.new(name: 'Joe', joint: 'false')
    account_owner_1.save
    visit new_account_path
    fill_in "Name", :with => "Test2"
    fill_in "Value", :with => "200.50"
    fill_in "Date opened", :with => "2014-12-10"
    select('Brokerage')
    select('Joe')
    click_button "Save Account"
    expect(Account.all.size).to eq(0)
    expect(page).to have_title("EZ Finance | Accounts")
  end

  scenario 'they try to update an account' do
    account_owner_1 = AccountOwner.new(name: 'Joe', joint: 'false')
    account_owner_1.save
    account = Account.build_and_save_account(name: 'Test', value: '100', account_owner: account_owner_1)
    account.save
    visit edit_account_path(account)
    fill_in "Name", :with => "Test2"
    select('Brokerage')
    click_button "Save Account"
    expect(Account.first.name).to eq('Test')
    expect(page).to have_title("EZ Finance | Accounts")
  end

  scenario 'they try to create an account type' do
    visit new_account_type_path
    fill_in "Description", :with => "New Type"
    click_button "Save Account Type"
    expect(AccountType.find_by description: 'New Type').to eq(nil)
  end

  scenario 'they try to update an account owner' do
    owner = AccountOwner.new(name: 'Joe', joint: 'false')
    owner.save
    visit edit_account_owner_path(owner.id)
    check("account_owner_joint")
    click_button "Save Account Owner"
    expect((AccountOwner.find_by name: 'Joe').joint).to eq(false)
  end
end
