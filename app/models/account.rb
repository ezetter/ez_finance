class Account < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper

  has_many :account_history, dependent: :destroy
  belongs_to :account_type
  belongs_to :account_owner

  def displayed_value
    if self.value_fractional > 0
      value = self.value + self.value_fractional/100.0

      number_with_precision(value, :precision => 2, :delimiter => ',')
    else
      number_with_precision(self.value, :precision => 0, :delimiter => ',')
    end
  end

  def self.save_account(account, params)
    value_int, value_frac = value_parts(params[:value])
    account.value = value_int
    account.value_fractional = value_frac
    account.updated = Time.now
    account.name = params[:name]
    account.date_opened = params[:date_opened]
    account.account_type_id = params[:account_type_id]
    account.account_owner_id = params[:account_owner_id]
    result = true
    if account.changed?
      result = account.save
      if result
        AccountHistory.save_history(account)
      end
    end
    result
  end

  private

  def self.value_parts(value_string)
    value_parts = value_string.gsub(',', '').split('.')
    return value_parts[0].to_i, value_parts[1].to_i
  end


end