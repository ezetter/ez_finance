class AccountType < ActiveRecord::Base
  def retirement_yes_no
    retirement ? 'Yes' : 'No'
  end
end
