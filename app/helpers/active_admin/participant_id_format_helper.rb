module ActiveAdmin::ParticipantIdFormatHelper
  def hint(participant_id_format)
    begin
      regex = Regexp.new(participant_id_format)
    rescue StandardError
    end

    examples =
      if regex.nil?
        []
      else
        (1..10).map do |_x|
          regex.random_example
        rescue StandardError
          nil
        end.to_set.to_a.compact
      end

    if examples.empty?
      'Must be a valid regular expression.'
    else
      'Must be a valid regular expression. (For example, the regular ' \
      "expression #{participant_id_format} will match each of the following: " \
      "#{examples.join(', ')}.)"
    end
  end
end
