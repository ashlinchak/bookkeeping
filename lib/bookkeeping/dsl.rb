module Bookkeeping
  class DSL
    attr_reader :debits, :credits, :description, :reference
    attr_accessor :entry

    def initialize(entry)
      @debits ||= {}
      @credits ||= {}
      @entry = entry
    end

    def debit(account, amount)
      @debits ||= {}
      @debits[account] ||= 0
      @debits[account] += amount
    end

    def credit(account, amount)
      @credits ||= {}
      @credits[account] ||= 0
      @credits[account] += amount
    end

    def description(description)
      @description = description
    end

    def transactionable(transactionable)
      @transactionable = transactionable
    end

    def build
      entry.transactionable = @transactionable || entry.transactionable
      entry.description = @description || entry.description

      debits.each do |account, amount|
        entry.debit_amounts.build(account: account, amount: amount)
      end

      credits.each do |account, amount|
        entry.credit_amounts.build(account: account, amount: amount)
      end
    end

  end
end