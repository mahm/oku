FactoryGirl.define do
  factory :auction do
    association :item
    association :user
    title 'This is auction title'
    item_name 'This is item name'
    amount 1
    open_at Time.now + 1.hour
    close_at Time.now + 1.day
    first_price 0
    highest_price 0
    closed false
  end
end
