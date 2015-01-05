require 'rails_helper'

RSpec.describe Evaluation, :type => :model do
  let(:evaluater) { create(:user) }
  let(:evaluatee) { create(:user) }
  let(:evaluation) { evaluater.evaluations.build(evaluatee_id: evaluatee.id) }

  subject { evaluation }

  it { should be_valid }
end
