require 'rails_helper'

RSpec.describe User, :type => :model do
  it 'is valid with a valid email address and password made by 8 or more characters' do
    expect(build(:user)).to be_valid
  end

  it 'is invalid without a email address' do
    user = build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).not_to be_empty
  end

  it 'is invalid with a invalid email address' do
    user = build(:user, email: 'This is not a email address')
    user.valid?
    expect(user.errors[:email]).not_to be_empty
  end

  it 'is invalid without a password' do
    user = build(:user, password: nil)
    user.valid?
    expect(user.errors[:password]).not_to be_empty
  end
end
