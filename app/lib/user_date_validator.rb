module UserDateValidator
  def date_of_birth_in_future
    return false unless date_valid?(:dob)
    !dob.future? ? true : errors.add(:dob, I18n.t('user.errors.dob.future')) && false
  end

  def child_date_of_birth_in_future
    return false unless is_parent.eql?(true) && date_valid?(:child_dob)
    !child_dob.future? ? true : errors.add(:child_dob, I18n.t('user.errors.dob.future')) && false
  end

  private

  def date_valid?(dob)
    date_format = /\d{2}-\d{2}-(\d{4})$/
    send(dob).to_s.match?(date_format) ? true : errors.add(dob, I18n.t('user.errors.dob.invalid_format')) && false
  end
end
