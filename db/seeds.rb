puts "Seeds file is running..."

require 'nokogiri'
require 'fileutils'

def hebrew_to_numerical(hebrew_string)
  # puts "hebrew_string: #{hebrew_string}"
  hebrew_string = hebrew_string.force_encoding('UTF-8')
  hebrew_chars = 'אבגדהוזחטיכלמנסעפצקרשת'
  values = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 200, 300, 400]
  hebrew_string.chars.map { |char|
    index = hebrew_chars.index(char)
    values[index]
  }.sum
end

def numericise(chapter_verse)
  chapter, verse = chapter_verse.split(',')
  chapter = hebrew_to_numerical(chapter)
  verse = hebrew_to_numerical(verse)
  [chapter, verse]
end

def remove_punctuation(verse_text)
  verse_text.gsub(/[{](פ|ס|ש)[}]|[.,;:]/, "").gsub(/-/, " ")
end

def create_verse(paragraph_child, chapter_verse)
  puts "Chapter, verse: #{chapter_verse}"
  chapter, verse = numericise(chapter_verse)

  # Capture the verse text by concatenating the text of all sibling elements
  # until we reach the next <b> element
  verse_text = ''
  sibling = paragraph_child.next_sibling
  while sibling && sibling.name != 'b'
    verse_text += sibling.text
    sibling = sibling.next_sibling
  end

  # puts "Verse text w punc: #{verse_text}"
  verse_text = remove_punctuation(verse_text)
  # puts "Verse text w/o punc: #{verse_text}"
  verse = Verse.create!(
    chapter: chapter,
    verse_number: verse,
    text: verse_text
  )
  # puts "Created verse."
  verse
end

def create_words_from_verse(verse)
  verse_id = verse.id
  # puts "Creating words from #{verse.chapter}, #{verse.verse_number}: #{verse.id}"
  verse_split = verse.text.split.map(&:strip).reject(&:empty?)
  verse_split.each_with_index { |word, index|
    word_record = Word.create!(verse_id: verse_id, text: word, position: index + 1)
    # puts "Created word: #{word_record.attributes.inspect}"
  }
  puts "Created words from #{verse.chapter}, #{verse.verse_number}"
end

def find_matches(words)
  searched_words = {}
  words.each { |word|
    puts word.text
    if !searched_words[word.text]
      puts "Searching for #{word.text}"
      searched_words[word.text] = []
      words.each { |other_word|
        if other_word.text.include?(word.text)
          searched_words[word.text] << other_word.id
        end
      }
      searched_words[word.text].each { |matched_word_id|
        Match.create(word: word, matched_word_id: matched_word_id) unless Match.exists?(word: word, matched_word_id: matched_word_id)
      }
    end
  }
end

def parse_biblical_text(file_path)
  doc = File.open(file_path) { |f| Nokogiri::HTML(f) }
  started_processing = false

  doc.css('p').each { |paragraph|
    paragraph.children.each { |child|
      if child.name == 'b'
        chapter_verse = child.text
        if chapter_verse == 'א,א' && !started_processing
          started_processing = true
        end
        if started_processing
          verse = create_verse(child, chapter_verse)
          create_words_from_verse(verse)
          find_matches(Word.all)
        end
      end
    }
  }
end

# file_path = File.join(Rails.root, '..', 'Tanach_Text', 'x001', 'x', 'x01.htm')
# parse_biblical_text(file_path)

# ==============================================================================
# Create words from pre-existing Verse records:
# puts "Testing for Verse records..."
# Verse.first(10).each { |verse|
#   puts verse.attributes
# }
# count = Verse.count
# id = 1
# while id <= count
#   create_words_from_verse(Verse.find(id))
#   id += 1
# end
# ==============================================================================
# Create matches from pre-existing Word records:
find_matches(Word.all)

# Useful lines for another time:
# require 'nokogiri'
# require 'open-uri'   

# Set the folder path containing the HTML files
# folder_path = "/Users/nathanwiseman/Actualize/tanach_matches_project/Tanach_Text/k001/k"

# Get a list of all HTML files in the folder
# html_files = Dir.glob("#{folder_path}/*.htm")

# html_files.each { |file_path|
  # Open the HTML file
  # html = open("https://mechon-mamre.org/i/t/k/k0.htm") { |f| Nokogiri::HTML(f) }
  # html = File.open(file_path) { |f| Nokogiri::HTML(f) }
# }
  # Split the verse text into individual verses
  # verses = verse_text.split(/(?<=\.)\s*(?:{פ}|{ס}|{ש})?\s*/) # uses a positive lookbehind (?<=\.) to ensure that the split occurs after a period (.), and then matches any optional whitespace characters, followed by an optional paragraph, section, or book marker ({פ}, {ס}, or {ש}), and finally any additional whitespace characters.
  # verses = verse_text.scan(/(.*?) (.*?) (.*?)\.(.*?)?(?: {פ}| {ס}| {ש})?/) # Extract the book, chapter, verse number, and full verse text from the input string. Full explanation in comment below.

# Explanation of RegEx:
# 1. (.*?): This is a capture group ( parentheses () ) that matches any character ( . ) zero or more times ( * ) in a non-greedy way ( ? ). This group captures the book name. The non-greedy match ensures that we don't match too much text.

# 2. (.*?): This is another capture group that matches any character zero or more times in a non-greedy way. This group captures the chapter number.

# 3. (.*?): This is yet another capture group that matches any character zero or more times in a non-greedy way. This group captures the verse number.

# 4. \.: This matches a literal period ( . ) character, which separates the verse number from the verse text.

# 5. (.*?): This is the fourth capture group, which matches any character zero or more times in a non-greedy way. This group captures the full verse text.

# 6. (?: {פ}| {ס}| {ש})?: This is a non-capture group ( (?:) ) that matches one of the optional markers: פ, ס, or ש, each preceded by a space character. The ? at the end makes this group optional, so it will still match if the marker is not present.

# The (?:) syntax is called a non-capture group or a passive group. It groups the alternatives together, but it doesn't create a capture group, which means it won't be included in the match array.