module DashboardHelper
  def step_reviewed?(user, step)
    step_review(user, step).present?
  end

  def step_review(user, step)
    StepReview.find_by(
      user: user,
      consent_step: step
    )
  end

  def step_one_button(step_count)
    step_count == 1 ? t(:view) : t(:edit)
  end

  def dashboard_row_helper(user, step)
    if step_reviewed?(user, step)
      'dashboard__row_done'
    else
      'dashboard__row_active'
    end
  end

  def format_time(time)
    time = time.get_utc

    content_tag(:span,
                I18n.l(time, format: :long),
                data: {
                  time: time.iso8601
                })
  end
end
