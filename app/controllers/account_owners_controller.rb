class AccountOwnersController < ApplicationController
  before_filter :authorize_user, :only => [:create, :update, :destroy]

  def new
    @account_owner = AccountOwner.new
  end

  def create
    account_owner = AccountOwner.new
    account_owner.name = params[:account_owner][:name]
    account_owner.joint = params[:account_owner][:joint]
    if account_owner.save
      redirect_to action: 'index'
    else
      render action: 'new'
    end
  end

  def index
    @account_owners = AccountOwner.all.sort_by { |at| at.name }
  end

  def destroy
    account = AccountOwner.find(params[:id])
    account.delete
    redirect_to action: 'index'
  end

  def edit
    @account_owner = AccountOwner.find(params[:id])
  end

  def update
    account_owner = AccountOwner.find(params[:id])
    account_owner.name = params[:account_owner][:name]
    account_owner.joint = params[:account_owner][:joint]
    if account_owner.save
      flash[:notice] = 'Account owner updated!'
      redirect_to action: 'index'
    else
      render action: 'edit'
    end
  end

end
