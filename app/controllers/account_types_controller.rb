class AccountTypesController < ApplicationController
  before_filter :authorize_user, :only => [:create, :update, :destroy]

  def new
    @account_type = AccountType.new
  end

  def create
    account_type = AccountType.new
    add_attributes(account_type)
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
    add_attributes(account_type)
    if account_type.save
      flash[:notice] = 'Account type updated!'
      redirect_to action: 'index'
    else
      render action: 'edit'
    end
  end

  private

  def add_attributes(account_type)
    account_type.description = params[:account_type][:description]
    account_type.retirement = params[:account_type][:retirement]
  end
end
