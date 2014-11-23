class AccountsController < ApplicationController
  def new
    @account = Account.new
  end

  def create
    @account = Account.new(account_params)
    @account.updated = Time.new
    if @account.save
      flash[:notice] = 'Account created!'
      redirect_to action: 'index'
    else
      render action: 'new'
    end
  end

  def index
    @accounts = Account.all
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
    account.update_attributes(account_params)
    account.updated = Time.now
    if account.save
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
      unless k.to_i == v.to_i
        account.value = v.to_i
        account.updated = Time.now
        account.save
      end
    end
    flash[:notice] = 'Accounts updated!'
    redirect_to action: 'index'
  end

  private

  def account_params
    params.require(:account).permit(:name, :value)
  end
end