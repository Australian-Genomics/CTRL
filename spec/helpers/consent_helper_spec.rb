require 'rails_helper'

RSpec.describe ConsentHelper, type: :helper do
  describe '#collection_option_class' do
    it 'should return empty string if no option_value is passed' do
      expect(helper.collection_option_class).to eq ''
    end

    it 'should return "green mx-auto" string if option_value is Yes' do
      expect(helper.collection_option_class('Yes')).to include 'green mx-auto'
    end

    it 'should return "red mx-auto" string if option_value is No' do
      expect(helper.collection_option_class('No')).to include 'red mx-auto'
    end

    it 'should return "blue" string if option_value is Not Sure' do
      expect(helper.collection_option_class('Not Sure')).to include 'blue'
    end
  end
end
