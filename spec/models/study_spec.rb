require 'spec_helper'

RSpec.describe Study, type: :model do
  describe 'validate participant_id_format' do
    context 'when ParticipantIdFormat is not a valid regex' do
      let(:participant_id_format) { Study.create(name: 'default', participant_id_format: 'B1523456[') }

      it { expect(participant_id_format).to be_a(Study) }
      it { expect(participant_id_format.errors[:participant_id_format]).to eq(['participant ID format must be a valid regular expression; premature end of char-class: /B1523456[/']) }
    end

    context 'when Study has a valid Participant ID' do
      let(:participant_id_format) { Study.create(name: 'default', participant_id_format: 'A1543457') }

      it { expect(participant_id_format).to be_a(Study) }
      it { expect(participant_id_format.errors[:participant_id_format]).to eq([]) }
    end
  end
end
