FactoryGirl.define do
  factory :credits, :class => Bookkeeping::AssetAccount do
    name "credits"
    overdraft_enabled true

    association :accountable, factory: :user
  end
end
