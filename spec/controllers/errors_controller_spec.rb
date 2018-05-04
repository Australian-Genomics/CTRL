require 'rails_helper'

RSpec.describe ErrorsController, type: :controller do
  describe '#not_found' do
    it 'returns http success' do
      get :not_found
      expect(response).to have_http_status(404)
    end
  end

  describe '#internal_server_error' do
    it 'returns http success' do
      get :internal_server_error
      expect(response).to have_http_status(500)
    end
  end
end
