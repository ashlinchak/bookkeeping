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
  class Amount < ActiveRecord::Base

    belongs_to :entry, class_name: "Bookkeeping::Entry"
    belongs_to :account, class_name: "Bookkeeping::Account"

    validates :type, :amount, :balance_before, :balance_after, presence: true

    def account_name=(name)
      self.account = Account.find_by_name!(name)
    end

  end
end
