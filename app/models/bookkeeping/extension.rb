module Bookkeeping
  module Extension
    extend ActiveSupport::Concern

    module ProxyMethods

      [:asset, :expense, :liability, :equity, :income].each do |kind|
        define_method kind do |name, overdraft = true|
          define_method name do
            self[name, kind, overdraft]
          end
        end
      end

    end

    module ClassMethods

      def has_accounts(&block)
        has_many :accounts, as: :accountable, class_name: 'Bookkeeping::Account', inverse_of: :accountable do
          extend ProxyMethods

          class_eval(&block) if block
        end
      end

    end
  end
end