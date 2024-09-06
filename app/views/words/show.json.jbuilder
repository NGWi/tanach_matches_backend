json.extract! @word, :id, :verse_id, :position, :text
puts matches
matches.each { |match|
  puts match.matched_word
  json.set! match.id, {
  id: match.id,
  matched_word_id: match.matched_word_id,
  verse_id: match.matched_word.verse_id,
  text: match.matched_word.text
  }
}
