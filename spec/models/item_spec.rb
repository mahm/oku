require 'rails_helper'

RSpec.describe Item, :type => :model do
  it 'is valid with a user_id, category_id, name' do
    expect(build(:item)).to be_valid
  end

  it 'is invalid without a user_id' do
    item = build(:item, user_id: nil)
    item.valid?
    expect(item.errors[:user_id]).to include("can't be blank")
  end

  it 'is invalid without a category_id' do
    item = build(:item, category_id: nil)
    item.valid?
    expect(item.errors[:category_id]).to include("can't be blank")
  end

  it 'is invalid without a name' do
    item = build(:item, name: nil)
    item.valid?
    expect(item.errors[:name]).to include("can't be blank")
  end
end
