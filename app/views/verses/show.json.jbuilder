json.extract! @verse, :id, :chapter, :verse_number
json.words @verse.words { |word|
  json.extract! word, :id, :text
}
