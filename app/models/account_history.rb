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

  def self.get_history(params = {})
    select_string = '1=1 '
    query_params = []
    unless params[:account_id].blank?
      select_string += ' AND account_id = ?'
      query_params << params[:account_id]
    end
    unless params[:account_type_id].blank?
      select_string += ' AND accounts.account_type_id = ?'
      query_params << params[:account_type_id]
    end
    unless params[:account_owner_id].blank?
      select_string += ' AND accounts.account_owner_id = ?'
      query_params << params[:account_owner_id]
    end
    if params[:retirement] == "retirement_only"
      select_string += ' AND account_types.retirement = true '
    end
    if params[:retirement] == "non_retirement_only"
      select_string += ' AND account_types.retirement = false '
    end
    if select_string == '1==1 '
      AccountHistory.all
    else
      return AccountHistory.joins(account: :account_type)
                 .where(select_string, *query_params).sort_by { |h| h.id }
    end
  end

  def self.get_intervals(all_history, intervals, interval_size)
    historical_totals = []
    end_time = Time.now.beginning_of_day
    (0...intervals).each do |i|
      q_time = end_time - (i * interval_size).days
      total = all_history.select { |h| h.date_changed <= q_time}
                  .group_by { |h| h.account }
                  .map { |h| h[1].last.historical_value }.inject(:+)
      total = 0 unless total
      historical_totals << [q_time.strftime("%Y-%m-%d"), total]
    end
    return historical_totals
  end

end
