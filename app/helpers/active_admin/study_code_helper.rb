module ActiveAdmin::StudyCodeHelper
  def hint(study_code)
    begin
      regex = Regexp.new(study_code)
    rescue
    end

    examples = regex.nil? ?
      [] :
      (1..10).map { |x|
        begin
          regex.random_example
        rescue
          nil
        end
      }.to_set.to_a.compact

    examples.empty? ?
      'Must be a valid regular expression.' :
      "Must be a valid regular expression. (For example, the regular " \
      "expression #{study_code} will match each of the following: " \
      "#{examples.join(', ')}.)"
  end
end
