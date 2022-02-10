require 'spec_helper'

RSpec.describe ConsentGroup do
  let(:consent_group) { build(:consent_group) }

  subject { consent_group }

  it { is_expected.to be_valid }

  describe 'associations' do
    it { should belong_to(:consent_step) }
  end

  describe 'validations' do
    it { is_expected.to_not validate_presence_of(:header) }

    it {
      should validate_numericality_of(:order)
        .is_greater_than(0)
    }

    it {
      should validate_uniqueness_of(:order)
        .scoped_to(:consent_step_id)
    }
  end
end
