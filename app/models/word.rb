class Word < ApplicationRecord
  belongs_to :verse
  has_many :matches
  has_many :matched_words, through: :matches
end
