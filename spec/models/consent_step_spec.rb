require 'spec_helper'

RSpec.describe ConsentStep do
  let(:consent_step) { build(:consent_step) }

  subject { consent_step }

  it { is_expected.to be_valid }

  describe 'associations' do
    it {
      should have_many(:consent_groups)
        .dependent(:destroy)
    }

    it {
      should have_many(:users_reviewed)
        .dependent(:destroy)
    }

    it {
      should have_many(:modal_fallbacks)
        .dependent(:destroy)
    }
  end

  describe 'validations' do
    it {
      should validate_numericality_of(:order).is_greater_than(0)
    }

    it { should validate_uniqueness_of(:order) }

    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:popover) }
  end

  describe 'public interface' do
    describe 'modal_fallback' do
      let(:consent_step) { create(:consent_step) }
      let(:modal_fallbacks) do
        create_list(
          :modal_fallback,
          3,
          consent_step: consent_step
        )
      end

      before do
        modal_fallbacks
      end

      subject { consent_step.modal_fallback }

      it { is_expected.to eq modal_fallbacks.first }
    end
  end
end
