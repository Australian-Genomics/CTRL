class Question < ApplicationRecord
  enum answer: %w[false true not_sure]
end
