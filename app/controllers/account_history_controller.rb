class AccountHistoryController < ApplicationController

  def form
    @accounts = [['All accounts', 0]]
    @accounts += Account.all.sort.map {|acc| [acc.name, acc.id]}
  end

  def view
    intervals = 30
    interval_size = 1
    begin
      intervals = Integer(params[:intervals]) unless params[:intervals].empty?
      interval_size = Integer(params[:interval_size]) unless params[:interval_size].empty?
    rescue ArgumentError
      flash[:error] = "Invalid number entered."
      redirect_to action: 'form'
    end
    if params[:account_id] == '0'
      @displayed = "History for all accounts:"
    else
      account = Account.find(params[:account_id])
      @displayed = "History for account #{account.name}:"
    end
    get_history(intervals, interval_size, params[:account_id])
  end

  private

  def get_history(intervals, interval_size, account_id)
    if account_id == '0'
      all_history = AccountHistory.where('date_changed IS NOT NULL').sort_by { |h| h.id }
    else
      all_history = AccountHistory.where('date_changed IS NOT NULL AND account_id = ?', account_id)
                        .sort_by { |h| h.id }
    end
    end_time = Time.now.beginning_of_day
    @historical_totals = []
    (0...intervals).each do |i|
      q_time = end_time - (i * interval_size).days
      total = all_history.select { |h| h.date_changed < q_time }.group_by { |h| h.account }
                  .map { |h| h[1].last.historical_value }.inject(:+)
      total = 0 unless total
      @historical_totals << [q_time.strftime("%d/%m/%Y"), total]
    end
  end

end
