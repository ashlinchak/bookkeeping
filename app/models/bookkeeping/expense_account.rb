# == Schema Information
#
# Table name: bookkeeping_accounts
#
#  id                :integer          not null, primary key
#  name              :string
#  type              :string
#  overdraft_enabled :boolean          default(TRUE), not null
#  accountable_id    :integer
#  accountable_type  :string
#  created_at        :datetime
#  updated_at        :datetime
#

module Bookkeeping
  class ExpenseAccount < Account

    def self.balance
      all.select(:id).to_a.sum(&:balance)
    end

    def balance
      debits_balance - credits_balance
    end
  end
end
