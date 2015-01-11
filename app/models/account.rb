class Account < ActiveRecord::Base
  after_save :save_history

  has_many :account_history, dependent: :destroy
  belongs_to :account_type
  belongs_to :account_owner

  include ActionView::Helpers::NumberHelper

  def displayed_value
    self.value_fractional = 0 unless self.value_fractional
    self.value = 0 unless self.value
    value = self.value + self.value_fractional/100.0

    number_with_precision(value, :precision => 2, :delimiter => ',')
  end

  def self.build_and_save_account(params, account=nil)
    account = Account.new(params) unless account
    params[:value], params[:value_fractional] = value_parts(params[:value])
    params[:updated] = Time.now
    account.update(params)
    return account
  end

  def self.get_filter(params)
    select_string = '1=1 '
    query_params = []
    unless params[:account_id].blank?
      select_string += ' AND accounts.id = ?'
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
    return select_string, query_params
  end

  def self.filtered_accounts(params)
    select_string, query_params = get_filter(params)
    if select_string.strip == '1=1'
      Account.all
    else
      Account.joins(:account_type)
          .where(select_string, *query_params).sort_by { |h| h.id }
    end
  end

  def self.breakdown(type)
    case type
      when 'retirement'
        @slices = Account.all.group_by { |a| a.account_type.retirement ? 'retirement' : 'non-retirement' }
        .map do |k, v|
          [k, v.inject(0){|r, e| r + e.value}]
        end
      when 'type'
        @slices = Account.all.group_by { |a| a.account_type.description}
                      .map do |k, v|
          [k, v.inject(0){|r, e| r + e.value}]
        end
      when 'owner'
        @slices = Account.all.group_by { |a| a.account_owner.name}
                      .map do |k, v|
          [k, v.inject(0){|r, e| r + e.value}]
        end

      else
        @slices = Account.all.map { |a| [a.name, a.value] }
    end
  end

  private

  def save_history
    AccountHistory.save_history(self)
  end

  def self.value_parts(value_string)
    value_parts = value_string.gsub(',', '').split('.')
    return value_parts[0].to_i, value_parts[1].to_i
  end

end