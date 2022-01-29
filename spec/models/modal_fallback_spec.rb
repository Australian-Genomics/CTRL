require 'spec_helper'

RSpec.describe ModalFallback do
  let(:modal_fallback) { build(:modal_fallback) }

  subject { modal_fallback }

  it { is_expected.to be_valid }

  describe 'associations' do
    it { should belong_to(:consent_step) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:cancel_btn) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:review_answers_btn) }
  end
end
