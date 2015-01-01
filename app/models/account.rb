class Account < ActiveRecord::Base
  after_save :save_history

  has_many :account_history, dependent: :destroy
  belongs_to :account_type
  belongs_to :account_owner

  include ActionView::Helpers::NumberHelper

  def displayed_value
    self.value_fractional = 0 unless self.value_fractional
    self.value = 0 unless self.value
    value = self.value + self.value_fractional/100.0

    number_with_precision(value, :precision => 2, :delimiter => ',')
  end

  def self.build_and_save_account(params, account=nil)
    account = Account.new(params) unless account
    params[:value], params[:value_fractional] = value_parts(params[:value])
    params[:updated] = Time.now
    account.update(params)
    return account
  end

  private

  def save_history
    AccountHistory.save_history(self)
  end

  def self.value_parts(value_string)
    value_parts = value_string.gsub(',', '').split('.')
    return value_parts[0].to_i, value_parts[1].to_i
  end

end