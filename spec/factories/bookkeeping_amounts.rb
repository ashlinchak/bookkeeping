FactoryGirl.define do
  factory :debit_amount, :class => Bookkeeping::DebitAmount do
    description "description"
    is_debit true
  end
end
