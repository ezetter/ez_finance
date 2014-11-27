class AccountHistory < ActiveRecord::Base
  self.table_name = 'account_history'

  belongs_to :account
end
