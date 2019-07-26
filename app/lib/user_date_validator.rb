module UserDateValidator
  def date_of_birth_in_future
    return false unless date_valid?
    !dob.future? ? true : errors.add(:dob, I18n.t('user.errors.dob.future')) && false
  end

  def child_date_of_birth_in_future
    return unless is_parent == true
    return false unless child_date_valid?
    !child_dob.future? ? true : errors.add(:child_dob, I18n.t('user.errors.dob.future')) && false
  end

  private

  def date_valid?
    date_format = /\d{2}-\d{2}-(\d{4})$/
    dob.to_s.match?(date_format) ? true : errors.add(:dob, I18n.t('user.errors.dob.invalid_format')) && false
  end

  def child_date_valid?
    date_format = /\d{2}-\d{2}-(\d{4})$/
    child_dob.to_s.match?(date_format) ? true : errors.add(:child_dob, I18n.t('user.errors.dob.invalid_format')) && false
  end
end
