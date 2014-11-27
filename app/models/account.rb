class Account < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper

  def displayed_value
    if self.value_fractional > 0
      value = self.value + self.value_fractional/100.0

      number_with_precision(value, :precision => 2, :delimiter => ',')
    else
      number_with_precision(self.value, :precision => 0, :delimiter => ',')
    end
  end

end