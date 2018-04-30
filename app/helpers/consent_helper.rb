module ConsentHelper
  def collection_option_class(option_value)
    return '' unless option_value
    class_to_append = {
      'Yes': 'green mx-auto',
      'No': 'red mx-auto',
      'Not Sure': 'blue'
    }[option_value.to_sym]
    'controls controls__radio controls__radio_' + class_to_append + ' ml-sm-15'
  end
end
