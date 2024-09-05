class Word < ApplicationRecord
  belongs_to :Verse
  has_many :matches
  has_many :matched_words, through: :matches
end
