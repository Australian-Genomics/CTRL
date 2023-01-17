class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :check_token

  def duo_limitations
    study_ids = parse_duo_limitations_payload(request.raw_post)
    if study_ids.nil?
      return render json: {'error': 'Invalid payload'}, status: :unprocessable_entity
    end

    users = User.where(study_id: study_ids)

    duo_limitations_json = users.map do |user|
      [user.study_id, duo_limitations_for_user(user)]
    end.to_h

    render json: duo_limitations_json
  end

  def not_found
    render json: {'error': 'Not found'}, status: :not_found
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
    if x.class == Array and y.class == Array
      return merge_arrays(x, y)
    end

    if x.class != Hash or y.class != Hash
      return x == y ? x : nil
    end

    if x.keys.to_set != y.keys.to_set
      return nil
    end

    x.keys.map do |key|
      merged = merge(x[key], y[key])
      if merged.nil?
        return
      else
        [key, merged]
      end
    end.to_h
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
    rescue => e
      return nil
    end

    if parsed.class == Array && parsed.all? {|x| x.class == String}
      return parsed
    end
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

    if authorization_scheme.downcase() != 'bearer'
      authorization_failed
    elsif ApiUser.find_by(token_digest: token_digest).nil?
      authorization_failed
    end
  end

  def authorization_failed
    render json: {'error' => 'Unauthorized'}, :status => :unauthorized
  end
end
