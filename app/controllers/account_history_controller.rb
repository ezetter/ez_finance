class AccountHistoryController < ApplicationController

  def view
    begin
      intervals = Integer(params[:intervals])
      interval_size = Integer(params[:interval_size])
    rescue ArgumentError
      flash[:error] = "Invalid number entered."
      render :form, :status => :unprocessable_entity
    end
    get_history(intervals, interval_size)
  end

  private

  def get_history(intervals = 30, interval_size=1)
    all_history = AccountHistory.where('date_changed IS NOT NULL').sort_by { |h| h.id }
    end_time = Time.now.beginning_of_day
    @historical_totals = []
    (0..intervals).each do |i|
      q_time = end_time - (i * interval_size).days
      total = all_history.select { |h| h.date_changed < q_time }.group_by { |h| h.account }
                  .map { |h| h[1].last.historical_value }.inject(:+)
      total = 0 unless total
      @historical_totals << [q_time.strftime("%d/%m/%Y"), total]
    end
  end

end
