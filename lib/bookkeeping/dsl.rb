module Bookkeeping
  class DSL
    attr_reader :debits, :credits, :description, :reference

    def initialize
      @debits ||= {}
      @credits ||= {}
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

    def reference(reference)
      @reference = reference
    end

    def build
      Bookkeeping::Entry.new(reference: @reference, description: @description) do
        credits.each do |account, amount|
          t.credit_items.build(account: account, amount: amount)
        end
        debits.each do |account, amount|
          t.debit_items.build(account: account, amount: amount)
        end
      end
    end

  end
end