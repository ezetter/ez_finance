class AccountsController < ApplicationController
  include Common

  def new
    @account = Account.new
    init_account_category_selects
  end

  def create
    @account = Account.build_and_save_account(account_params)
    if @account.valid?
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
    init_account_category_selects
  end

  def update
    account = Account.find(params[:id])
    account = Account.build_and_save_account(account_params, account)
    if account.save
      flash[:notice] = 'Account updated!'
      redirect_to action: 'index'
    else
      render action: 'edit'
    end
  end

  def destroy
    Account.destroy(params[:id])
    redirect_to action: 'index'
  end

  def bulk_update
    params[:value].each do |k, v|
      account = Account.find(k)
      Account.build_and_save_account({:value => v}, account)
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
    params.require(:account).permit(:name, :value, :date_opened, :account_type_id)
  end

end