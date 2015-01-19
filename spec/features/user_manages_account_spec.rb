require "rails_helper"

feature 'User manages an account' do
  include Warden::Test::Helpers
  Warden.test_mode!

  before :each do
    DatabaseCleaner.clean
    Rails.application.load_seed
    user = FactoryGirl.create(:admin)
    login_as(user, :scope => :user, :run_callbacks => false)
  end

  scenario 'they visit the new account page' do
    visit new_account_path
    expect(page).to have_title("Create Account")
  end

  scenario 'they visit the edit page' do
    account = Account.build_and_save_account(name: 'Test', value: '100')
    account.save

    visit edit_account_path(account)
    expect(page).to have_title("Edit Account")
  end

  scenario 'they create the account' do
    account_owner_1 = AccountOwner.new(name: 'Joe', joint: 'false')
    account_owner_1.save
    visit new_account_path
    fill_in "Name", :with => "Test2"
    fill_in "Value", :with => "200.50"
    fill_in "Date opened", :with => "2014-12-10"
    select('Brokerage')
    select('Joe')
    click_button "Save Account"
    expect(Account.first.name).to eq('Test2')
    expect(Account.first.value).to eq(200)
    expect(Account.first.value_fractional).to eq(50)
    expect(Account.first.account_type.description).to eq('Brokerage')
  end

  scenario 'they update the account' do
    account_owner_1 = AccountOwner.new(name: 'Joe', joint: 'false')
    account_owner_1.save
    account = Account.build_and_save_account(name: 'Test', value: '100', account_owner: account_owner_1)
    account.save
    visit edit_account_path(account)
    fill_in "Name", :with => "Test2"
    fill_in "Value", :with => "200.50"
    fill_in "Date opened", :with => "2014-12-10"
    select('Brokerage')
    click_button "Save Account"
    expect(Account.first.name).to eq('Test2')
    expect(Account.first.value).to eq(200)
    expect(Account.first.value_fractional).to eq(50)
    expect(Account.first.account_type.description).to eq('Brokerage')
  end

  scenario 'they create an account type' do
    visit new_account_type_path
    fill_in "Description", :with => "New Type"
    click_button "Save Account Type"
    expect((AccountType.find_by description: 'New Type').description).to eq("New Type")
  end

  scenario 'they update an account owner' do
    owner = AccountOwner.new(name: 'Joe', joint: 'false')
    owner.save
    visit edit_account_owner_path(owner.id)
    check("account_owner_joint")
    click_button "Save Account Owner"
    expect((AccountOwner.find_by name: 'Joe').joint).to eq(true)
  end

end