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
  class Account < ActiveRecord::Base

    # Associations
    belongs_to :accountable, polymorphic: true
    has_many :debit_amounts, dependent: :destroy
    has_many :credit_amounts, dependent: :destroy

    # Validations
    validates :name, presence: true

    class NotFound < StandardError; end
    class BadKind < StandardError; end

    class << self

      def by_kind(kind)
        Bookkeeping.const_get "#{kind.to_s.capitalize}Account"
      end

      def [](name, kind = nil, overdraft = true)

        unless account = find_by(name: name)
          raise NotFound, "account #{name} not found. Provide kind to create a new one" unless kind
          
          raise BadKind if kind && !class_exists?("Bookkeeping::#{kind.to_s.classify}Account")

          return by_kind(kind).create!(name: name.to_s, overdraft_enabled: overdraft)
        end

        raise BadKind if kind && by_kind(kind) != account.class

        account.update_attributes! overdraft_enabled: overdraft if overdraft != account.overdraft_enabled?

        return account
      end

      def total_balance
        raise(NoMethodError, "undefined method 'total_balance'") unless self == Bookkeeping::Account

        Bookkeeping::AssetAccount.balance + Bookkeeping::ExpenseAccount.balance - Bookkeeping::LiabilityAccount.balance - Bookkeeping::EquityAccount.balance - Bookkeeping::IncomeAccount.balance
      end

      def balanced?
        total_balance == 0
      end

      def class_exists?(class_name)
        klass = Module.const_get(class_name)
        return klass.is_a?(Class)
      rescue NameError
        return false
      end
    end
    private_class_method :class_exists?

    def debits_balance
      debit_amounts.sum(:amount)
    end

    def credits_balance
      credit_amounts.sum(:amount)
    end

    def overdraft?
      balance < 0
    end
  end
end
