class AccountsController < ApplicationController
  include Common

  def new
    @account = Account.new
  end

  def create
    @account = Account.new
    value_int, value_frac = value_parts(params[:account][:value])
    if save_account(@account, value_int, value_frac, params[:account][:name])
      flash[:notice] = 'Account created!'
      redirect_to action: 'index'
    else
      render action: 'new'
    end
  end

  def index
    @accounts = apply_filters
    @total = @accounts.inject(0) { |sum, acct| sum + acct.value}
    @selected_retirement = params[:retirement]
    @selected_account_owner_id = params[:account_owner_id]
    @selected_account_type_id = params[:account_type_id]

    init_account_category_selects
  end

  def show
    @account = Account.find(params[:id])
  end

  def edit
    @account = Account.find(params[:id])
  end

  def update
    account = Account.find(params[:id])
    value_int, value_frac = value_parts(params[:account][:value])
    if save_account(account, value_int, value_frac, params[:account][:name])
      flash[:notice] = 'Account updated!'
      redirect_to action: 'index'
    else
      render action: 'edit'
    end
  end

  def destroy
    account = Account.find(params[:id])
    Account.delete(params[:id])
    AccountHistory.destroy_all(:account => account)
    redirect_to action: 'index'
  end

  def bulk_update
    params[:value].each do |k, v|
      account = Account.find(k)
      value_int, value_frac = value_parts(v)
      unless account.value == value_int && account.value_fractional == value_frac
        save_account(account, value_int, value_frac)
      end
    end
    flash[:notice] = 'Accounts updated!'
    redirect_to action: 'index'
  end

  private

  def apply_filters
    select_string = '1=1 '
    query_params = []
    unless params[:account_type_id].blank?
      select_string += ' AND account_type_id = ?'
      query_params << params[:account_type_id]
    end
    unless params[:account_owner_id].blank?
      select_string += ' AND account_owner_id = ?'
      query_params << params[:account_owner_id]
    end
    if params[:retirement] == "retirement_only"
      select_string += ' AND account_types.retirement = true '
    end
    if params[:retirement] == "non_retirement_only"
      select_string += ' AND account_types.retirement = false '
    end
    Account.joins(:account_type)
                      .where(select_string, *query_params).sort_by { |a| a.name }
  end

  def account_params
    params.require(:account).permit(:name, :value)
  end

  def value_parts(value_string)
    value_parts = value_string.gsub(',','').split('.')
    return value_parts[0].to_i, value_parts[1].to_i
  end

  def save_account(account, value_int, value_frac, account_name = account.name)
    account.value = value_int
    account.value_fractional = value_frac
    account.updated = Time.now
    account.name = account_name
    if params[:account] && params[:account][:account_type_id]
      account.account_type = AccountType.find(params[:account][:account_type_id])
    end
    if params[:account] && params[:account][:account_owner_id]
      account.account_owner = AccountOwner.find(params[:account][:account_owner_id])
    end

    result = account.save
    if result
      AccountHistory.save_history(account)
    end
    result
  end

end