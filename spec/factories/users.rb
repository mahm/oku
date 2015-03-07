FactoryGirl.define do
  factory :user do
    sequence(:email) {
      Faker::Config.locale = :en
      Faker::Internet.email('dummy')
     }
    password 'x' * 8
  end
end
