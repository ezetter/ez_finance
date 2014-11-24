class AccountsController < ApplicationController
  def new
    @account = Account.new
  end

  def create
    @account = Account.new
    value_int, value_frac = value_parts(params[:account][:value])
    if set_account_fields(@account, value_int, value_frac, params[:account][:name]).save
      flash[:notice] = 'Account created!'
      redirect_to action: 'index'
    else
      render action: 'new'
    end
  end

  def index
    @accounts = Account.all.sort
    @total = @accounts.inject(0) { |sum, acct| sum + acct.value}
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
    if set_account_fields(account, value_int, value_frac, params[:account][:name]).save
      flash[:notice] = 'Account updated!'
      redirect_to action: 'index'
    else
      render action: 'edit'
    end
  end

  def destroy
    account = Account.find(params[:id])
    account.delete
  end

  def bulk_update
    params[:value].each do |k, v|
      account = Account.find(k)
      value_int, value_frac = value_parts(v)
      unless account.value == value_int && account.value_fractional == value_frac
        set_account_fields(account, value_int, value_frac).save
      end
    end
    flash[:notice] = 'Accounts updated!'
    redirect_to action: 'index'
  end

  private

  def account_params
    params.require(:account).permit(:name, :value)
  end

  def value_parts(value_string)
    value_parts = value_string.gsub(',','').split('.')
    return value_parts[0].to_i, value_parts[1].to_i
  end

  def set_account_fields(account, value_int, value_frac, account_name = account.name)
    account.value = value_int
    account.value_fractional = value_frac
    account.updated = Time.now
    account.name = account_name
    account
  end

end