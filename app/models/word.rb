class Word < ApplicationRecord
  belongs_to :verse
  has_many :matches
  has_many :matched_words, through: :matches
  has_many :inverse_matches, class_name: 'Match', foreign_key: 'matched_word_id'
  has_many :roots, through: :inverse_matches, source: :word
end
