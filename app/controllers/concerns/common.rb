module Common
  extend ActiveSupport::Concern

  def init_account_category_selects
    @account_types = AccountType.all.sort_by { |at| at.description }
                         .map { |at| [at.description, at.id] }
    @account_owners = AccountOwner.all.sort_by { |at| at.description }
                          .map { |at| [at.description, at.id] }
    @retirement_options = [['Retirement Only', :retirement_only], ['Non-Retirement Only', :non_retirement_only]]
  end

  def flash_validation_errors(model)
    flash[:alert] = "Unable to save: " + model.errors.full_messages.join(', ')
  end

end
