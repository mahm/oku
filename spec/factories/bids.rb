FactoryGirl.define do
  factory :bid do
    association :auction
    association :user
    price [*1..10000].sample
  end
end
