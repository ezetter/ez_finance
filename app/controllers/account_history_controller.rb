class AccountHistoryController < ApplicationController

  def index
    all_history = AccountHistory.where('date_changed IS NOT NULL').sort_by { |h| h.id }
    now = Time.now
    @historical_totals = []
    (0..30).each do |i|
      q_time = now - i.days
      total = all_history.select { |h| h.date_changed <q_time }.group_by { |h| h.account }
                  .map { |h| h[1].last.historical_value }.inject(:+)
      total = 0 unless total
      @historical_totals << [q_time.strftime("%d/%m/%Y"), total]
    end
  end

end
