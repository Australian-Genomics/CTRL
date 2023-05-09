require 'spec_helper'
require 'base64'

RSpec.describe ApplicationController, type: :controller do
  describe '#logo' do
    it 'returns the default logo when none is set' do
      SurveyConfig.create(name: APPLICATION_LOGO_PNG, value: '')

      get :logo
      expect(response.stream.to_path).to eq(
        Rails.root.join(
          'app', 'assets', 'images', 'australian-genomics-logo.png'
        )
      )
    end

    it 'returns the custom logo when one is set' do
      base64 = 'iVBORw0KGgoAAAANSUhEUgAAAQAAAAEAAQMAAABmvDolAAAAA1BMVEW10NBjB' \
        'BbqAAAAH0lEQVRoge3BAQ0AAADCoPdPbQ43oAAAAAAAAAAAvg0hAAABmmDh1QAAAABJR' \
        'U5ErkJggg=='
      binary = Base64.decode64(base64)
      SurveyConfig.create(name: APPLICATION_LOGO_PNG, value: base64)

      get :logo
      expect(response.stream.body).to eq(binary)
    end
  end
end
