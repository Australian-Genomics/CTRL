class Question < ApplicationRecord
  enum answer: ['false', 'true', 'Not Sure']
end
