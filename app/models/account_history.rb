class AccountHistory < ActiveRecord::Base
  self.table_name = 'account_history'

  belongs_to :account

  def self.save_history(account)
    history = AccountHistory.where('date_changed=? AND account_id=?', account.updated, account)[0]
    unless history
      history = AccountHistory.new
      history.account = account
      history.date_changed = account.updated
    end
    history.historical_value = "#{account.value}.#{account.value_fractional}".to_f
    history.save
  end

end
