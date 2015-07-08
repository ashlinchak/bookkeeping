# == Schema Information
#
# Table name: bookkeeping_amounts
#
#  id         :integer          not null, primary key
#  type       :string
#  is_debit   :boolean          default(TRUE), not null
#  account_id :integer
#  entry_id   :integer
#  amount     :decimal(20, 2)   default(0.0)
#

module Bookkeeping
  class CreditAmount < Amount

    after_initialize :init

    def init
      self.is_debit = false
    end
  end
end
