class StepsController < ApplicationController
  def update
    @step = Step.find(params[:id])
    @step.update(step_params)
    @step.touch

    redirect_to(path_to_redirect)
  end

  private

  def step_params
    params.require(:step).permit(:accepted, questions_attributes: %i[answer id question_id user_id])
  end

  def path_to_redirect
    step_to_redirect = step_number_requested

    return redirect_path_for_step_four if params[:to_dashboard_from_three]
    return redirect_path_for_step_three if params[:to_dashboard]

    return dashboard_index_path unless step_to_redirect

    case step_to_redirect
    when 'three' then redirect_path_for_step_three
    when 'four' then redirect_path_for_step_four
    else redirect_path_for_other_steps(step_to_redirect)
    end
  end

  def redirect_path_for_other_steps(step_to_redirect)
    options = {}
    options[:controller] = 'consent'
    options[:action] = 'step_' + step_to_redirect
    options[('registration_step_' + step_to_redirect).to_sym] = true
    options
  end

  def step_number_requested
    %w[two three four five].each do |step_number|
      param_to_check = ('registration_step_' + step_number).to_sym
      return step_number if params[param_to_check]
    end
    nil
  end

  def redirect_path_for_step_three
    if step_params[:questions_attributes].select { |x| step_params[:questions_attributes][x][:answer] == 'false' }.empty?
      check_params_for_confirm_answers
    else
      check_params_for_review_answers('from_step_two')
    end
  end

  def redirect_path_for_step_four
    if step_params[:questions_attributes].select { |x| step_params[:questions_attributes][x][:answer] == 'false' }.empty?
      if params[:to_dashboard_from_three]
        dashboard_index_path
      else
        step_four_path(registration_step_four: true)
      end
    else
      check_params_for_review_answers('from_step_three')
    end
  end

  def check_params_for_confirm_answers
    if params[:to_dashboard]
      confirm_answers_path(to_dashboard: true)
    else
      confirm_answers_path
    end
  end

  def check_params_for_review_answers(step_number)
    if params[:to_dashboard]
      review_answers_path(to_dashboard: true, "#{step_number}": true)
    elsif params[:to_dashboard_from_three]
      review_answers_path(to_dashboard_from_three: true, "#{step_number}": true)
    else
      review_answers_path("#{step_number}": true)
    end
  end
end
