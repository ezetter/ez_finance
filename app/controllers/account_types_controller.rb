class AccountTypesController < ApplicationController

  def new
    @account_type = AccountType.new
  end

  def create
    account_type = AccountType.new
    account_type.description = params[:account_type][:description]
    if account_type.save
      redirect_to action: 'index'
    else
      render action: 'new'
    end
  end

  def index
    @account_types = AccountType.all.sort_by { |at| at.description }
  end

  def destroy
    account = AccountType.find(params[:id])
    account.delete
    redirect_to action: 'index'
  end

  def edit
    @account_type = AccountType.find(params[:id])
  end

  def update
    account_type = AccountType.find(params[:id])
    account_type.description = params[:account_type][:description]
    if account_type.save
      flash[:notice] = 'Account type updated!'
      redirect_to action: 'index'
    else
      render action: 'edit'
    end
  end
end
