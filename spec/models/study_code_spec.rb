require 'spec_helper'

RSpec.describe StudyCode, type: :model do
  describe 'validate title' do
    context 'when StudyCode is not a valid regex' do
      let(:study_code) { StudyCode.create(title: 'B1523456[') }

      it { expect(study_code).to be_a(StudyCode) }
      it { expect(study_code.errors[:title]).to eq(['study code must be a valid regular expression; premature end of char-class: /B1523456[/']) }
    end

    context 'when StudyCode has a valid Study id' do
      let(:study_code) { StudyCode.create(title: 'A1543457') }

      it { expect(study_code).to be_a(StudyCode) }
      it { expect(study_code.errors[:title]).to eq([]) }
    end
  end
end
