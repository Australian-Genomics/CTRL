module NextOfKinRegistrationValidator
  def next_of_kin_needed_to_register?
    sc = SurveyConfig.find_by(name: NEXT_OF_KIN_NEEDED_TO_REGISTER)
    ActiveModel::Type::Boolean.new.cast(sc&.value)
  end
end
