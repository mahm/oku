require 'rails_helper'

RSpec.describe Category, :type => :model do
  it 'is invalid without a name' do
    category = build(:category, name: nil)
    category.valid?
    expect(category.errors[:name]).to include("can't be blank")
  end

  it 'is valid with a name' do
    expect(build(:category)).to be_valid
  end
end
