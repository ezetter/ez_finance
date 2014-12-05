class AccountHistoryController < ApplicationController
  include Common

  def index
    @accounts = Account.all.sort.map { |acc| [acc.name, acc.id] }
    init_account_category_selects
    @intervals = 30
    @interval_size = 1
    @historical_totals = []
    show_history if params[:show_history]
  end

  private

  def show_history
    begin
      @intervals = Integer(params[:intervals]) unless params[:intervals].empty?
      @interval_size = Integer(params[:interval_size]) unless params[:interval_size].empty?
    rescue ArgumentError
      flash[:warn] = "Invalid number entered."
      return
    end
    get_history
  end

  def get_history
    select_string = 'date_changed IS NOT NULL'
    query_params = []
    unless params[:account_id].empty?
      select_string += ' AND account_id = ?'
      query_params << params[:account_id]
    end
    unless params[:account_type_id].empty?
      select_string += ' AND accounts.account_type_id = ?'
      query_params << params[:account_type_id]
    end
    unless params[:account_owner_id].empty?
      select_string += ' AND accounts.account_owner_id = ?'
      query_params << params[:account_owner_id]
    end
    if params[:retirement] == "retirement_only"
      select_string += ' AND account_types.retirement = true '
    end
    if params[:retirement] == "non_retirement_only"
      select_string += ' AND account_types.retirement = false '
    end
    all_history = AccountHistory.joins(account: :account_type)
                      .where(select_string, *query_params).sort_by { |h| h.id }

    end_time = Time.now.beginning_of_day
    (0...@intervals).each do |i|
      q_time = end_time - (i * @interval_size).days
      total = all_history.select { |h| h.date_changed < q_time }.group_by { |h| h.account }
                  .map { |h| h[1].last.historical_value }.inject(:+)
      total = 0 unless total
      @historical_totals << [q_time.strftime("%Y-%m-%d"), total]
    end
  end

end
