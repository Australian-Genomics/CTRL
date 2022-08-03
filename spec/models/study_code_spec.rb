require 'spec_helper'

RSpec.describe StudyCode, type: :model do
  describe 'validate title' do
    context 'when study id not started with capital A' do
      let(:study_code) { StudyCode.create(title: 'B1523456') }

      it { expect(study_code).to be_a(StudyCode) }
      it { expect(study_code.errors).not_to be_empty }
      it { expect(study_code.errors[:title]).to eq(['Invalid study code format']) }
    end

    context 'when first number is not between 0 to 4 after capital A' do
      let(:study_code) { StudyCode.create(title: 'A5123456') }

      it { expect(study_code).to be_a(StudyCode) }
      it { expect(study_code.errors).not_to be_empty }
      it { expect(study_code.errors[:title]).to eq(['Invalid study code format']) }
    end

    context 'when third number is not between 2 to 4 after capital A' do
      let(:study_code) { StudyCode.create(title: 'A1563456') }

      it { expect(study_code).to be_a(StudyCode) }
      it { expect(study_code.errors).not_to be_empty }
      it { expect(study_code.errors[:title]).to eq(['Invalid study code format']) }
    end

    context 'when length of numbers after capital A is less than 7' do
      let(:study_code) { StudyCode.create(title: 'A154345') }

      it { expect(study_code).to be_a(StudyCode) }
      it { expect(study_code.errors).not_to be_empty }
      it { expect(study_code.errors[:title]).to eq(['Invalid study code format']) }
    end

    context 'when length of numbers after capital A is greater than 7' do
      let(:study_code) { StudyCode.create(title: 'A15434577') }

      it { expect(study_code).to be_a(StudyCode) }
      it { expect(study_code.errors).not_to be_empty }
      it { expect(study_code.errors[:title]).to eq(['Invalid study code format']) }
    end

    context 'when StudyCode has a valid Study id' do
      let(:study_code) { StudyCode.create(title: 'A1543457') }

      it { expect(study_code).to be_a(StudyCode) }
      it { expect(study_code.errors[:title]).to eq([]) }
    end
  end
end
