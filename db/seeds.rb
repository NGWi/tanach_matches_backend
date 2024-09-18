file_name = "x01.htm"
puts "Seeds file is running..."

require "nokogiri"

def hebrew_to_numerical(hebrew_string)
  hebrew_string = hebrew_string.force_encoding("UTF-8")
  hebrew_chars = "אבגדהוזחטיכלמנסעפצקרשת"
  values = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 200, 300, 400]
  hebrew_string.chars.map { |char|
    index = hebrew_chars.index(char)
    values[index]
  }.sum
end

def numericise(chapter_verse)
  chapter, verse = chapter_verse.split(",")
  chapter = hebrew_to_numerical(chapter)
  verse = hebrew_to_numerical(verse)
  [chapter, verse]
end

def remove_punctuation(verse_text)
  verse_text.gsub(/[{](פ|ס|ש)[}]|[.,;:]/, "").gsub(/-/, " ")
end

def create_verse(paragraph_child, chapter_verse, book)
  puts "Chapter, verse: #{chapter_verse}"
  chapter, verse = numericise(chapter_verse)

  # Capture the verse text by concatenating the text of all sibling elements
  # until we reach the next <b> element
  verse_text = ""
  sibling = paragraph_child.next_sibling
  while sibling && sibling.name != "b"
    verse_text += sibling.text
    sibling = sibling.next_sibling
  end

  verse_text = remove_punctuation(verse_text)
  verse = Verse.create!(
    book: book,
    chapter: chapter,
    verse_number: verse,
    text: verse_text,
  )
  verse
end

def create_words_from_verse(verse)
  verse_id = verse.id
  verse_split = verse.text.split.map(&:strip).reject(&:empty?)
  verse_split.each_with_index { |word, index|
    word_record = Word.create!(verse_id: verse_id, text: word, position: index + 1)
  }
  puts "Created words from #{verse.chapter}, #{verse.verse_number}"
end

def find_matches(words)
  count = words.count
  searched_words = {}
  words.each { |word|
    puts word.text
    if !searched_words[word.text]
      puts "Searching for #{word.text}"
      searched_words[word.text] = true
      words.each { |other_word|
        if other_word.text.include?(word.text)
          Match.create(word: word, matched_word_id: other_word.id) unless Match.exists?(word: word, matched_word_id: other_word.id)
        end
      }
    end
    puts "Created matches for #{100.0 * (word.id / count)}% of words"
  }
end

def parse_biblical_text(file_path)
  doc = File.open(file_path) { |f| Nokogiri::HTML(f) }
  started_processing = false
  book = nil
  doc.css("p").each { |paragraph|
    paragraph.children.each { |child|
      if child.name == "b"
        chapter_verse = child.text
        if chapter_verse == "א,א" && !started_processing
          started_processing = true
          book = child.previous_element("h1").text
        end
        if started_processing
          verse = create_verse(child, chapter_verse, book)
          create_words_from_verse(verse)
        end
      end
    }
  }
  find_matches(Word.all)
end

file_path = File.join(Rails.root, "db", "raw_htm_text", file_name)
parse_biblical_text(file_path)

# ==============================================================================
# Set all verses with no book to specified book:
# Verse.where(book: nil).update_all(book: "Breishis")
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
# find_matches(Word.all)

# ==============================================================================

## Other options:
# Open an online HTML file:
# require 'open-uri'
# html = open("https://mechon-mamre.org/i/t/k/k0.htm") { |f| Nokogiri::HTML(f) }

# Process a bunch of files:
# require 'fileutils'
# folder_path = File.join(Rails.root, "db", "raw_htm_text")
# html_files = Dir.glob("#{folder_path}/*.htm")
# html_files.each { |file_path|
#   parse_biblical_text(file_path)
# }
