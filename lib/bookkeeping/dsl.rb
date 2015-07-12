module Bookkeeping
  class DSL
    attr_reader :__debits, :__credits, :__description, :__reference

    def initialize(entry, &block)
      @__debits = {}
      @__credits = {}

      self.extend Bookkeeping::Proxy
      self.caller = block.binding.eval "self"

      @__entry = entry

      instance_eval &block
    end

    def debit(account, amount)
      @__debits[account] ||= 0
      @__debits[account] += amount
    end

    def credit(account, amount)
      @__credits[account] ||= 0
      @__credits[account] += amount
    end

    def description(description)
      @__description = description
    end

    def transactionable(transactionable)
      @__transactionable = transactionable
    end

    def entry
      @__entry
    end

    def entry=(entry)
      @__entry = entry
    end

    def build
      entry.transactionable = @__transactionable || entry.transactionable
      entry.description = @__description || entry.description

      __debits.each do |account, amount|
        entry.debit_amounts.build(account: account, amount: amount)
      end

      __credits.each do |account, amount|
        entry.credit_amounts.build(account: account, amount: amount)
      end

      entry
    end

  end
end