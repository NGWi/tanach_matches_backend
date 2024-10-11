class Match < ApplicationRecord
  belongs_to :word
  belongs_to :matched_word, class_name: "Word", foreign_key: "matched_word_id"
end
