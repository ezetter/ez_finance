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
    @historical_totals = AccountHistory.get_intervals(AccountHistory.get_history(params), @intervals, @interval_size)
  end

end
