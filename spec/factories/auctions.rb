FactoryGirl.define do
  factory :auction do
    association :user
    category_id 1
    title 'This is auction title'
    amount 1
    open_at { Time.now + 1.hour }
    close_at { Time.now + 1.day }
    first_price 0
    closed false
  end
end
