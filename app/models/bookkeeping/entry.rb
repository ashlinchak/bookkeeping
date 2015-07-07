# == Schema Information
#
# Table name: bookkeeping_entries
#
#  id                   :integer          not null, primary key
#  description          :string
#  transactionable_id   :integer
#  transactionable_type :string
#  rollback_entry_id    :integer
#  created_at           :datetime
#  updated_at           :datetime
#

module Bookkeeping
  class Entry < ActiveRecord::Base

    belongs_to :transactionable, polymorphic: true
    has_many :amounts, dependent: :destroy
    has_many :debit_amounts, class_name: "Bookkeeping::DebitAmount"
    has_many :credit_amounts, class_name: "Bookkeeping::CreditAmount"

    validates :transactionable, :description, presence: true
    validate :has_credit_amounts?
    validate :has_debit_amounts?
    validate :amounts_cancel?

    def self.prepare(options = {}, &block)
      new(options) do |entry|
        dsl = Bookkeeping::DSL.new(entry)
        dsl.instance_eval &block
        dsl.build
      end
    end

# TODO: not work
    def rollback!(ref = nil)
      tran = self
      res = self.class.prepare do
        tran.debit_amounts.each { |di| debit(di.account, -di.amount) }
        tran.credit_amounts.each { |ci| credit(ci.account, -ci.amount) }
        transactionable(ref || tran)
        description("Rollback of #{tran.description}")
      end
      self.rollback_transaction_id = res.id
      save!
      res
    end

    private

      def has_credit_amounts?
        errors[:base] << "Entry must have at least one credit amount" if self.credit_amounts.blank?
      end

      def has_debit_amounts?
        errors[:base] << "Entry must have at least one debit amount" if self.debit_amounts.blank?
      end

      def amounts_cancel?
        errors[:base] << "The credit and debit amounts are not equal" if credit_amounts.to_a.sum(&:amount) != debit_amounts.to_a.sum(&:amount)
      end
  end
end
