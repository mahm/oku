FactoryGirl.define do
  factory :bid do
    association :auction
    association :user
    price 1
  end
end
