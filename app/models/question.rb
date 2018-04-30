class Question < ApplicationRecord
  enum answer: ['false', 'true', 'not_sure']
end
