class ConsentController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def step_one
    @step = current_user.step_one
    render 'step_one.html.erb'
  end

  def step_two
    @step = current_user.step_two
    @step.build_question_for_step(:two, current_user.id) if @step.questions.empty?
    render 'step_two.html.erb'
  end

  def step_three
    @step = current_user.step_three
    @step.build_question_for_step(:three, current_user.id) if @step.questions.empty?
    render 'step_three.html.erb'
  end

  def step_four
    @step = current_user.step_four
    @step.build_question_for_step(:four, current_user.id) if @step.questions.empty?
    render 'step_four.html.erb'
  end

  def step_five
    @step = current_user.step_five
    @step.build_question_for_step(:five, current_user.id) if @step.questions.empty?
    render 'step_five.html.erb'
  end

  def confirm_answers; end

  def review_answers; end
end
