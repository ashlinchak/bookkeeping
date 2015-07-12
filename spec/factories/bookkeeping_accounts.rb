FactoryGirl.define do
  factory :credits, :class => Bookkeeping::AssetAccount do
    name "credits"
    overdraft_enabled true

    association :accountable, factory: :user
  end

  factory :income, :class => Bookkeeping::IncomeAccount do
    name "income"
    overdraft_enabled true

    association :accountable, factory: :user
  end
end
