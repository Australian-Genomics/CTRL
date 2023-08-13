RSpec.describe AnswerQuestion do
  let(:question) { create(:consent_question) }
  let(:study_user) { create(:study_user) }

  describe '#call' do
    context 'answer doesn\'t exist' do
      let(:answer_params) do
        {
          consent_question_id: question.id,
          answer: 'yes'
        }
      end

      it 'saves the answer' do
        expect do
          AnswerQuestion.call(answer_params, study_user.user)
        end.to change(QuestionAnswer, :count).by(1)

        answer = QuestionAnswer.first

        expect(answer.answer).to eq('yes')
      end
    end

    context 'there is an existing answer from the user' do
      let!(:answer) do
        create(
          :question_answer,
          consent_question: question,
          user: study_user.user,
          answer: 'yes'
        )
      end

      let(:answer_params) do
        {
          consent_question_id: question.id,
          answer: 'no'
        }
      end

      it 'updates the existing answer' do
        answer = QuestionAnswer.first

        expect(answer.reload.answer).to eq('yes')

        expect do
          AnswerQuestion.call(answer_params, study_user.user)
        end.to change(QuestionAnswer, :count).by(0)

        expect(answer.reload.answer).to eq('no')
      end
    end

    context 'consent question does not exist' do
      let(:answer_params) do
        {
          consent_question_id: 123,
          answer: 'yes'
        }
      end

      it 'raises an error' do
        expect do
          AnswerQuestion.call(answer_params, study_user.user)
        end.to change(QuestionAnswer, :count).by(0)
                                             .and raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
