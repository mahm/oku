FactoryGirl.define do
  factory :item do
    association :user
    association :category
    name 'MacBook Pro 15inch late 2010'
    explanation %Q{
それは黄金の昼下がり
気ままにただようぼくら
オールは二本ともあぶなげに
小さな腕で漕がれ
小さな手がぼくらのただよいを導こうと
かっこうだけ申し訳につけて
ああ残酷な三人！こんな時間に
}
  end
end
