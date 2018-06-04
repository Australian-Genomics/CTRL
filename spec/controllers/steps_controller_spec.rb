require 'rails_helper'

describe StepsController do
  describe '#update' do
    let(:step) { FactoryBot.create :step }

    context 'when no query param is present' do
      subject { put :update, params: { id: step.id, step: { accepted: true } } }

      it 'should redirect to dashboard' do
        expect(subject).to redirect_to(dashboard_index_path)
      end
    end

    context 'when to_dashboard=true is passed' do
      context 'when all answers are true' do
        subject { put :update, params: { id: step.id, to_dashboard: true, step: { accepted: true, questions_attributes: { '0' => { answer: 'true' }, '1' => { answer: 'true' } } } } }

        it 'should redirect to consent#confirm_answer' do
          expect(subject).to redirect_to(confirm_answers_path(to_dashboard: true))
        end
      end

      context 'when any one of the answers is false' do
        subject { put :update, params: { id: step.id, to_dashboard: true, step: { accepted: true, questions_attributes: { '0' => { answer: 'true' }, '1' => { answer: 'false' } } } } }

        it 'should redirect to consent#review_answer' do
          expect(subject).to redirect_to(review_answers_path(to_dashboard: true))
        end
      end
    end

    context 'when registration_step_two=true is passed' do
      subject { put :update, params: { id: step.id, registration_step_two: true, step: { accepted: true } } }

      it 'should redirect to consent#step_two' do
        expect(subject).to redirect_to(step_two_url(registration_step_two: true))
      end
    end

    context 'when registration_step_three=true is passed' do
      context 'when all answers are true' do
        subject { put :update, params: { id: step.id, registration_step_three: true, step: { accepted: true, questions_attributes: { '0' => { answer: 'true' }, '1' => { answer: 'true' } } } } }

        it 'should redirect to consent#confirm_answer' do
          expect(subject).to redirect_to(confirm_answers_path)
        end
      end

      context 'when any one of the answers is false' do
        subject { put :update, params: { id: step.id, registration_step_three: true, step: { accepted: true, questions_attributes: { '0' => { answer: 'true' }, '1' => { answer: 'false' } } } } }

        it 'should redirect to consent#review_answer' do
          expect(subject).to redirect_to(review_answers_path)
        end
      end
    end

    context 'when registration_step_four=true is passed' do
      subject { put :update, params: { id: step.id, registration_step_four: true, step: { accepted: true } } }

      it 'should redirect to consent#four' do
        expect(subject).to redirect_to(step_four_url(registration_step_four: true))
      end
    end

    context 'when registration_step_five=true is passed' do
      subject { put :update, params: { id: step.id, registration_step_five: true, step: { accepted: true } } }

      it 'should redirect to consent#step_five' do
        expect(subject).to redirect_to(step_five_url(registration_step_five: true))
      end
    end
  end
end
