class Match < ApplicationRecord
  belongs_to :word
  belongs_to :matched_word, class_name: "Word"
end
