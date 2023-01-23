require 'spec_helper'

RSpec.describe ApiController, type: :request do
  let(:test_token) { SecureRandom.hex(10) }

  let(:user) { create(:user) }

  let(:other_user) { create(:user) }

  let(:consent_question_1) { create(:consent_question) }
  let(:consent_question_2) { create(:consent_question) }
  let(:consent_question_3) { create(:consent_question) }

  let(:invalid_headers) { {'Authorization': "Bearer invalid-#{test_token}"} }

  let(:headers) { {'Authorization': "Bearer #{test_token}"} }

  before do
    ConditionalDuoLimitation.create!(
      json: '
        {
          "duo_limitation": {
            "code": "DUO:0000004",
            "modifiers": [ { "code": "DUO:0000046" } ]
          },
          "condition": true
        }
      '.strip,
    )
    ConditionalDuoLimitation.create!(
      json: %Q{
        {
          "duo_limitation": {
            "code": "DUO:0000004",
            "modifiers": [ { "code": "DUO:0000019" } ]
          },
          "condition": {
            "consent_question_id": #{consent_question_1.id},
            "answer": "yes"
          }
        }
      }.strip
    )
    ConditionalDuoLimitation.create!(
      json: %Q{
        {
          "duo_limitation": {
            "code": "DUO:0000004",
            "modifiers": [ { "code": "DUO:0000046" } ]
          },
          "condition": {
            "consent_question_id": #{consent_question_1.id},
            "answer": "no"
          }
        }
      }.strip
    )
    ConditionalDuoLimitation.create!(
      json: %Q{
        {
          "duo_limitation": { "code": "DUO:0000011", "modifiers": [] },
          "condition": {
            "and": [
              {
                "or": [
                  {
                    "consent_question_id": #{consent_question_1.id},
                    "answer": "no"
                  },
                  { "and": [true, false] },
                  false
                ]
              },
              {
                "not": {
                  "consent_question_id": #{consent_question_2.id},
                  "answer": "no"
                }
              },
              {
                "consent_question_id": #{consent_question_1.id},
                "answer_exists": true
              },
              {
                "consent_question_id": #{consent_question_3.id},
                "answer_exists": { "and": [true, false] }
              }
            ]
          }
        }
      }.strip
    )

    ApiUser.create!(
      name: 'test-name',
      token_digest: Digest::SHA256.hexdigest(test_token),
    )
  end

  describe '#duo_limitations' do
    it 'yields a HTTP 402 response when an invalid token is provided' do
      post '/api/v1/duo_limitations', headers: invalid_headers

      expect(response.stream.body).to eq('{"error":"Unauthorized"}')
      expect(response).to be_unauthorized
    end

    it "yields a HTTP 422 when the payload isn't syntactically correct JSON" do
      post '/api/v1/duo_limitations', params: '[', headers: headers

      expect(response.stream.body).to eq('{"error":"Invalid payload"}')
      expect(response.response_code).to eq(422)
    end

    it "yields a HTTP 422 when the payload isn't an array of strings" do
      post '/api/v1/duo_limitations', params: '[3, 4]', headers: headers

      expect(response.stream.body).to eq('{"error":"Invalid payload"}')
      expect(response.response_code).to eq(422)
    end

    it "ignores study IDs which don't exist" do
      request_body = %Q{ ["doesnt-exist", "doesnt-exist-either"] }.strip
      post '/api/v1/duo_limitations', params: request_body, headers: headers

      expect(response.stream.body).to eq('{}')
      expect(response).to be_successful
    end

    it "yields only the DUO limitation which is unconditionally true when no questions are answered" do
      request_body = %Q{ ["#{user.study_id}"] }
      response_body = %Q{
        {"#{user.study_id}":[{"code":"DUO:0000004","modifiers":[{"code":"DUO:0000046"}]}]}
      }.strip

      post '/api/v1/duo_limitations', params: request_body, headers: headers

      expect(response.stream.body).to eq(response_body)
      expect(response).to be_successful
    end

    it "yields merged DUO limitations when multiple conditions are satisfied" do
      QuestionAnswer.create!(
        consent_question: consent_question_1,
        user: user,
        answer: 'yes',
      )

      request_body = %Q{ ["#{user.study_id}"] }
      response_body = %Q{
        {"#{user.study_id}":[{"code":"DUO:0000004","modifiers":[{"code":"DUO:0000046"},{"code":"DUO:0000019"}]}]}
      }.strip

      post '/api/v1/duo_limitations', params: request_body, headers: headers

      expect(response.stream.body).to eq(response_body)
      expect(response).to be_successful
    end

    it "correctly evaluates a condition using all the logical operators and literals" do
      QuestionAnswer.create!(
        consent_question: consent_question_1,
        user: user,
        answer: 'no',
      )
      QuestionAnswer.create!(
        consent_question: consent_question_2,
        user: user,
        answer: 'yes',
      )

      request_body = %Q{ ["#{user.study_id}"] }
      response_body = %Q{
        {"#{user.study_id}":[{"code":"DUO:0000004","modifiers":[{"code":"DUO:0000046"}]},{"code":"DUO:0000011","modifiers":[]}]}
      }.strip

      post '/api/v1/duo_limitations', params: request_body, headers: headers

      expect(response.stream.body).to eq(response_body)
      expect(response).to be_successful
    end

    it "yields DUO limitations for the right user" do
      QuestionAnswer.create!(
        consent_question: consent_question_1,
        user: user,
        answer: 'yes',
      )

      request_body = %Q{ ["#{user.study_id}", "#{other_user.study_id}"] }
      response_body = %Q{
        {
          "#{user.study_id}":[
            {
              "code": "DUO:0000004",
              "modifiers": [{"code": "DUO:0000046"}, {"code": "DUO:0000019"}]
            }
          ],
          "#{other_user.study_id}":[
            {
              "code": "DUO:0000004",
              "modifiers": [{"code":"DUO:0000046"}]
            }
          ]
        }
      }.gsub(/\s+/, "")

      post '/api/v1/duo_limitations', params: request_body, headers: headers

      expect(response.stream.body).to eq(response_body)
      expect(response).to be_successful
    end
  end
end
