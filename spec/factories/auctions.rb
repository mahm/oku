FactoryGirl.define do
  factory :auction do
    association :item
    association :user
    open_at Time.now + 1.hour
    close_at Time.now + 1.day
    first_price 0
    highest_price 0
    closed false
  end
end
