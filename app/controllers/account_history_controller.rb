class AccountHistoryController < ApplicationController
  include Common

  def index
    @accounts = Account.all.sort.map { |acc| [acc.name, acc.id] }
    init_account_category_selects
    @historical_totals = []
    load_history
    if params[:view] == 'chart'
      render "chart"
    end
  end

  private

  def load_history
    begin
      @intervals = params[:intervals] ? Integer(params[:intervals]) : 30
      @interval_size = params[:interval_size] ? Integer(params[:interval_size]) : 1
    rescue ArgumentError
      flash[:warn] = "Invalid number entered."
      return
    end
    @historical_totals = AccountHistory.get_intervals(AccountHistory.get_history(params), @intervals, @interval_size)
  end

end
