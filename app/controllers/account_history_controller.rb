class AccountHistoryController < ApplicationController
  include Common

  def form
    @accounts = Account.all.sort.map { |acc| [acc.name, acc.id] }
    init_account_category_selects
  end

  def view
    intervals = 30
    interval_size = 1
    begin
      intervals = Integer(params[:intervals]) unless params[:intervals].empty?
      interval_size = Integer(params[:interval_size]) unless params[:interval_size].empty?
    rescue ArgumentError
      flash[:warn] = "Invalid number entered."
      redirect_to action: 'form'
    end
    if params[:account_id].empty? && params[:account_type_id].empty? && params[:account_owner_id].empty?
      @displayed = "History for all accounts:"
    else
      filters = []
      filters << "#{Account.find(params[:account_id]).name}" unless params[:account_id].empty?
      filters << "type #{AccountType.find(params[:account_type_id]).description}" unless params[:account_type_id].empty?
      filters << "owner #{AccountOwner.find(params[:account_owner_id]).name}" unless params[:account_owner_id].empty?
      @displayed = "History for account #{filters.join(' and ')}:"
    end
    get_history(intervals, interval_size)
  end

  private

  def get_history(intervals, interval_size)
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
    @historical_totals = []
    (0...intervals).each do |i|
      q_time = end_time - (i * interval_size).days
      total = all_history.select { |h| h.date_changed < q_time }.group_by { |h| h.account }
                  .map { |h| h[1].last.historical_value }.inject(:+)
      total = 0 unless total
      @historical_totals << [q_time.strftime("%Y-%m-%d"), total]
    end
  end

end
