class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :check_token

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
      x.evaluate_condition(user) ? [x.duo_limitation] : []
    end

    ConditionalDuoLimitation.merge_arrays([], user_duo_limitations)
  end

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
    render json: {'error' => 'Authorization failed'}, :status => :unauthorized
  end
end
