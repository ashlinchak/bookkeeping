FactoryGirl.define do
  factory :entry, :class => Bookkeeping::Entry do
    description "description"

    association :transactionable, factory: :user
  end
end
