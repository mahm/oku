require 'rails_helper'

RSpec.describe Category, :type => :model do
  it 'is invalid without a code' do
    category = build(:category, code: nil)
    category.valid?
    expect(category.errors[:code]).to include("can't be blank")
  end

  it 'is invalid when code is dupulicate' do
    create(:category, code: 1)
    category = build(:category, code: 1)
    category.valid?
    expect(category.errors[:code]).to include("has already been taken")
  end

  it 'is invalid without a name' do
    category = build(:category, name: nil)
    category.valid?
    expect(category.errors[:name]).to include("can't be blank")
  end

  it 'is valid with a name' do
    expect(build(:category)).to be_valid
  end
end
