require 'spec_helper'

RSpec.describe ConsentQuestion do
  let(:consent_question) { build(:consent_question) }

  subject { consent_question }

  it { is_expected.to be_valid }

  describe 'associations' do
    it {
      should have_many(:answers)
        .dependent(:destroy)
    }

    it {
      should have_many(:question_options)
        .dependent(:destroy)
    }

    it { should belong_to(:consent_group) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:question) }

    it {
      is_expected.to validate_inclusion_of(:default_answer)
        .in_array(['yes', 'no'])
    }

    it { is_expected.to validate_presence_of(:answer_choices_position) }

    it { is_expected.to validate_presence_of(:question_type) }

    it { is_expected.to_not validate_presence_of(:redcap_field) }

    it {
      is_expected.to validate_inclusion_of(:answer_choices_position)
        .in_array(ConsentQuestion::POSITIONS)
    }

    it {
      is_expected.to validate_inclusion_of(:question_type)
        .in_array(ConsentQuestion::QUESTION_TYPES)
    }

    it {
      should validate_numericality_of(:order).is_greater_than(0)
    }

    it {
      should validate_numericality_of(:order)
        .is_greater_than(0)
    }

    it {
      should validate_uniqueness_of(:order)
        .scoped_to(:consent_group_id)
    }
  end
end
