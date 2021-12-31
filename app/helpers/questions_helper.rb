module QuestionsHelper
  def all_questions
    {
      step_two_questions: step_two_questions,
      step_three_questions: step_three_questions,
      step_four_questions: step_four_questions,
      step_five_questions: step_five_questions
    }
  end

  def step_two_questions
    questions = []
    for num in 1..10 do
      questions << {
        question_id: num,
        qus: I18n.t("questions.step_two.question_#{num}.question"),
        description: I18n.t("questions.step_two.question_#{num}.description"),
        default_value: true
      }
    end
    questions << {
      question_id: 11,
      qus: I18n.t('questions.step_two.question_11.question'),
      description: I18n.t('questions.step_two.question_11.description'),
      default_value: false
    }
    questions
  end

  def step_three_questions
    questions = []
    for num in 12..14 do
      questions << {
        question_id: num,
        qus: I18n.t("questions.step_three.question_#{num}.question"),
        description: I18n.t("questions.step_three.question_#{num}.description"),
        default_value: true
      }
    end
    questions << {
      question_id: 15,
      qus: I18n.t('questions.step_three.question_15.question'),
      description: I18n.t('questions.step_three.question_15.description'),
      default_value: false
    }
    questions
  end

  def step_four_questions
    questions = []
    for num in 16..20 do
      questions << {
        question_id: num,
        qus: I18n.t("questions.step_four.question_#{num}.question"),
        description: I18n.t("questions.step_four.question_#{num}.description"),
        default_value: 'not_sure'
      }
    end
    questions << {
      question_id: 21,
      qus: I18n.t('questions.step_four.question_21.question'),
      description: I18n.t('questions.step_four.question_21.description'),
      default_value: false
    }
    questions
  end

  def step_five_questions
    questions = []
    for num in 22..32 do
      questions << {
        question_id: num,
        qus: I18n.t("questions.step_five.question_#{num}.question"),
        description: I18n.t("questions.step_five.question_#{num}.description"),
        default_value: 'not_sure'
      }
    end
    questions << {
      question_id: 33,
      qus: I18n.t('questions.step_five.question_33.question'),
      description: I18n.t('questions.step_five.question_21.description'),
      default_value: false
    }
    questions << {
      question_id: 34,
      qus: I18n.t('questions.step_five.question_34.question'),
      description: I18n.t('questions.step_five.question_21.description'),
      default_value: false
    }
    questions
  end
end
