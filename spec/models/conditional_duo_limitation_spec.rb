require 'spec_helper'

RSpec.describe ConditionalDuoLimitation do
  it 'is fails schema validation for unknown DUO codes' do
    json = %(
      {
        "duo_limitation": {
          "code": "DUO:doesnt-exist",
          "modifiers": []
        },
        "condition": true
      }
    ).strip

    c = ConditionalDuoLimitation.new(json: json)
    c.save

    expect(c.errors.full_messages).to all(match(/schema specific errors/))
  end

  it 'it fails semantics validation for non-existent consent question IDs in equals exprs' do
    json = %(
      {
        "duo_limitation": {
          "code": "DUO:0000004",
          "modifiers": []
        },
        "condition": {
          "consent_question_id": -1,
          "answer": "yes"
        }
      }
    ).strip

    c = ConditionalDuoLimitation.new(json: json)
    c.save

    expect(c.errors.full_messages).to eq([
                                           'Json No consent question exists having the consent_question_id -1'
                                         ])
  end

  it 'it fails semantics validation for non-existent consent question IDs in exists exprs' do
    json = %(
      {
        "duo_limitation": {
          "code": "DUO:0000004",
          "modifiers": []
        },
        "condition": {
          "consent_question_id": -1,
          "answer_exists": true
        }
      }
    ).strip

    c = ConditionalDuoLimitation.new(json: json)
    c.save

    expect(c.errors.full_messages).to eq([
                                           'Json No consent question exists having the consent_question_id -1'
                                         ])
  end

  it 'is fails semantics validation for non-existent answers' do
    consent_question = create(:consent_question)

    json = %(
      {
        "duo_limitation": {
          "code": "DUO:0000004",
          "modifiers": []
        },
        "condition": {
          "consent_question_id": #{consent_question.id},
          "answer": "'doesn't exist'"
        }
      }
    ).strip

    c = ConditionalDuoLimitation.new(json: json)
    c.save

    expect(c.errors.full_messages).to eq([
                                           "Json The question whose consent_question_id is #{consent_question.id} " \
                                           'can only have the values (yes, no)'
                                         ])
  end

  it 'saves relationships to consent questions mentioned in the JSON document' do
    related_consent_question = create(:consent_question)
    other_related_consent_question = create(:consent_question)

    unrelated_consent_question = create(:consent_question)

    json = %(
      {
        "duo_limitation": {
          "code": "DUO:0000004",
          "modifiers": []
        },
        "condition": {
          "and": [
            {
              "consent_question_id": #{related_consent_question.id},
              "answer": "yes"
            },
            {
              "consent_question_id": #{other_related_consent_question.id},
              "answer_exists": false
            }
          ]
        }
      }
    ).strip

    c = ConditionalDuoLimitation.new(json: json)
    c.save

    related_consent_question_ids = c.consent_questions.map(&:id).to_set

    expected_consent_question_ids = [
      related_consent_question.id,
      other_related_consent_question.id
    ].to_set

    expect(related_consent_question_ids).to eq(expected_consent_question_ids)
    expect(
      related_consent_question_ids.include?(unrelated_consent_question)
    ).to eq(false)
  end
end
