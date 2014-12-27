FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "dummy#{n}@example.com" }
    password 'x' * 8
  end
end
