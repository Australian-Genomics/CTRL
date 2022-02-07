class SurveyResponsesController < ApplicationController
  before_action :authenticate_user!

  def index
    @responses = question_answers(current_user)
    respond_to do |format|
      format.pdf do
        render pdf: 'index'
      end
    end
  end

  private

  def question_answers(user)
    QuestionAnswer.where(user: user)
  end
end
