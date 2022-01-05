class ConsentController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def step_one
    @step = current_user.step_one
  end

  def step_two
    @step = current_user.step_two
    @step.build_question_for_step(current_user.id) if @step.questions.empty?
  end

  def step_three
    @step = current_user.step_three
    @step.build_question_for_step(current_user.id) if @step.questions.empty?
  end

  def step_four
    @step = current_user.step_four
    @step.build_question_for_step(current_user.id) if @step.questions.empty?
  end

  def step_five
    @step = current_user.step_five
    @step.build_question_for_step(current_user.id) if @step.questions.empty?
  end

  def confirm_answers; end

  def review_answers; end

  def notification_consent; end
end
