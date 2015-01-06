require 'rails_helper'

RSpec.describe User, :type => :model do
  it 'is valid with a valid email address and password made by 8 or more characters' do
    expect(build(:user)).to be_valid
  end

  it 'is invalid without a email address' do
    user = build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end

  it 'is invalid with a invalid email address' do
    user = build(:user, email: 'This is not a email address')
    user.valid?
    expect(user.errors[:email]).to include("is invalid")
  end

  it 'is invalid without a password' do
    user = build(:user, password: nil)
    user.valid?
    expect(user.errors[:password]).to include("can't be blank")
  end

  it 'is invalid with a password less than 7 characters' do
    user = build(:user, password: 'x' * 7)
    user.valid?
    expect(user.errors[:password]).to include("is too short (minimum is 8 characters)")
  end

  describe 'Evaluate other user' do
    let(:evaluater) { create(:user) }
    let(:evaluatee) { create(:user) }
    let(:comment) {
      %Q{それは黄金の昼下がり
気ままにただようぼくら
オールは二本ともあぶなげに
小さな腕で漕がれ
小さな手がぼくらのただよいを導こうと
かっこうだけ申し訳につけて
ああ残酷な三人！こんな時間に}
    }

    it 'should be success when a user is not evaluate other user yet' do
      evaluater.evaluate!(evaluatee, comment)
      expect(evaluater).to be_evaluate(evaluatee)
      expect(evaluater.evaluatees).to include(evaluatee)
      expect(evaluatee.evaluaters).to include(evaluater)
    end
  end
end
