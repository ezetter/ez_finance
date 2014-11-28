class AccountOwner < ActiveRecord::Base

  def description
    "#{self.name} #{joint ? '(joint)' : ""}"
  end
end
