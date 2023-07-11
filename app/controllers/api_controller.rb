class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :check_token

  def duo_limitations
    participant_ids = parse_duo_limitations_payload(request.raw_post)
    return render json: { 'error': 'Invalid payload' }, status: :unprocessable_entity if participant_ids.nil?

    study_users = StudyUser.where(participant_id: participant_ids)

    duo_limitations_json = study_users.map do |study_user|
      [study_user.participant_id, duo_limitations_for_user(study_user.user)]
    end.to_h

    render json: duo_limitations_json
  end

  def not_found
    render json: { 'error': 'Not found' }, status: :not_found
  end

  private

  #
  # Example:
  #
  #   x = {
  #     "code": "DUO:1",
  #     "modifiers": [
  #       { "code": "DUO:2", "regions": ["US"] },
  #       { "code": "DUO:3", "regions": ["EU"] }
  #     ]
  #   }
  #
  #   y = {
  #     "code": "DUO:1",
  #     "modifiers": [
  #       { "code": "DUO:2", "regions": ["AU"] },
  #       { "code": "DUO:4", "regions": ["NZ"] }
  #     ]
  #   }
  #
  #   merge(x, y) == {
  #     "code": "DUO:1",
  #     "modifiers": [
  #       { "code": "DUO:2", "regions": ["US", "AU"] }
  #       { "code": "DUO:3", "regions": ["EU"] }
  #       { "code": "DUO:4", "regions": ["NZ"] }
  #     ]
  #   }
  #
  def merge(x, y)
    return merge_arrays(x, y) if x.instance_of?(Array) && y.instance_of?(Array)

    if (x.class != Hash) || (y.class != Hash)
      return x == y ? x : nil
    end

    return nil if x.keys.to_set != y.keys.to_set

    merged_hashes = x.keys.map do |key|
      [key, merge(x[key], y[key])]
    end.to_h

    merged_hashes.values.any?(&:nil?) ? nil : merged_hashes
  end

  def merge_into_array(array, x)
    was_merged = false

    merged = array.map do |y|
      merged = merge(y, x)
      was_merged ||= !merged.nil?
      merged.nil? ? y : merged
    end

    was_merged ? merged : array + [x]
  end

  def merge_arrays(xs, ys)
    (xs + ys).reduce([]) do |acc, z|
      merge_into_array(acc, z)
    end
  end

  def parse_duo_limitations_payload(payload)
    parsed = begin
      JSON.parse(payload)
    rescue StandardError
      return nil
    end

    return parsed if parsed.instance_of?(Array) && parsed.all? { |x| x.instance_of?(String) }
  end

  def duo_limitations_for_user(user)
    user_duo_limitations = ConditionalDuoLimitation.all.flat_map do |x|
      x.eval_condition(user) ? [x.duo_limitation] : []
    end

    merge_arrays([], user_duo_limitations)
  end

  def check_token
    authorization_header = (request.headers['Authorization'] || '').split

    authorization_scheme = authorization_header[0] || ''
    authorization_token = authorization_header[1] || ''

    token_digest = Digest::SHA256.hexdigest(authorization_token)

    if !authorization_scheme.casecmp('bearer').zero?
      authorization_failed
    elsif ApiUser.find_by(token_digest: token_digest).nil?
      authorization_failed
    end
  end

  def authorization_failed
    render json: { 'error' => 'Unauthorized' }, status: :unauthorized
  end
end
