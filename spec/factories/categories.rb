FactoryGirl.define do
  factory :category do
    code [*1000..9999].sample
    name 'パソコン・周辺機器'
  end
end
