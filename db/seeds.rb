puts "Seeds file is running..."

require 'nokogiri'
require 'fileutils'

def hebrew_to_numerical(hebrew_string)
  hebrew_chars = 'אבגדהוזחטיכלמנסעפצקרשת'
  values = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 200, 300, 400]
  hebrew_string.split('').map { |char|
    index = hebrew_chars.index(char)
    values[index]
  }.sum
end

def parse_biblical_text(file_path)
  doc = File.open(file_path) { |f| Nokogiri::HTML(f) }
  data = []

  # Find all <h1> elements that contain chapter titles
  doc.css('p').each { |verse_element|
    # Extract verse text
    verse_text = verse_element.text
    puts "Verse text: #{verse_text}"
    # Extract chapter and verse numbers from the verse text
    if verse_text =~ /\b(א),([א-ת]+)\b/
      chapter = hebrew_to_numerical($1)
      verse_number = hebrew_to_numerical($2)
      data << {
        chapter: chapter,
        verse_number: verse_number,
        text: verse_text
      }
    end
  }

  puts "Data: #{data.inspect}"
  data
end

file_path = File.join(Rails.root, '..', 'Tanach_Text', 'k001', 'k', 'k01.htm')
data = parse_biblical_text(file_path)

# Seed the data into the database
data.each { |verse|
  puts "Creating verse #{verse[:chapter]}, #{verse[:verse_number]}: #{verse[:text]}"
  verse_instance = Verse.create!(chapter: verse[:chapter], verse_number: verse[:verse_number], text: verse[:text])
  puts "Created verse instance: #{verse_instance.inspect}"
  # Split the verse text into individual words
  # words = verse[:text].split
  
  # # Create and save Word instances for each word
  # words.each { |word|
  #   Word.create!(text: word, position: words.index(word) + 1, verse_id: verse_instance.id)
  # }
}

# require 'nokogiri'
# require 'open-uri'
# require 

    

# Set the folder path containing the HTML files
# folder_path = "/Users/nathanwiseman/Actualize/tanach_matches_project/Tanach_Text/k001/k"

# Get a list of all HTML files in the folder
# html_files = Dir.glob("#{folder_path}/*.htm")

# html_files.each { |file_path|
# To just run it on one file:
# file_path = '/Users/nathanwiseman/Actualize/tanach_matches_project/Tanach_Text/k001/k/k01.htm'
  # Open the HTML file
  # html = open("https://mechon-mamre.org/i/t/k/k0.htm") { |f| Nokogiri::HTML(f) }
# html = File.open(file_path) { |f| Nokogiri::HTML(f) }

  # Extract the verse text
  # verse_text = html.css("p").map(&:text).join # assumes that all the HTML files are in the same folder, and that the verse text is contained within <p> elements

  # Split the verse text into individual verses
  # verses = verse_text.split(/(?<=\.)\s*(?:{פ}|{ס}|{ש})?\s*/) # uses a positive lookbehind (?<=\.) to ensure that the split occurs after a period (.), and then matches any optional whitespace characters, followed by an optional paragraph, section, or book marker ({פ}, {ס}, or {ש}), and finally any additional whitespace characters.
  # verses = verse_text.scan(/(.*?) (.*?) (.*?)\.(.*?)?(?: {פ}| {ס}| {ש})?/) # Extract the book, chapter, verse number, and full verse text from the input string. Full explanation in comment below.

  # verses.each { |verse|
  #   # Extract the book, chapter, and verse number
  #   # book, chapter, verse_number = verse_text.match(/^(.*?) (.*?) (.*?) /).captures
  #   book, chapter, verse_number, verse_text = verse

  #   # Create a new Verse record
  #   verse = Verse.create!(book: book, chapter: chapter.to_i, verse_number: verse_number.to_i, text: verse_text)

  #   # Split the verse text into individual words
  #   words = verse_text.split(/[\s,.;:]+/)

  #   words.each { |word_text|
  #     # Create a new Word record
  #     word = Word.create!(text: word_text, position: words.index(word_text) + 1, verse: verse)
  #   }
  # }
# }

# Explanation of RegEx:
# 1. (.*?): This is a capture group ( parentheses () ) that matches any character ( . ) zero or more times ( * ) in a non-greedy way ( ? ). This group captures the book name. The non-greedy match ensures that we don't match too much text.

# 2. (.*?): This is another capture group that matches any character zero or more times in a non-greedy way. This group captures the chapter number.

# 3. (.*?): This is yet another capture group that matches any character zero or more times in a non-greedy way. This group captures the verse number.

# 4. \.: This matches a literal period ( . ) character, which separates the verse number from the verse text.

# 5. (.*?): This is the fourth capture group, which matches any character zero or more times in a non-greedy way. This group captures the full verse text.

# 6. (?: {פ}| {ס}| {ש})?: This is a non-capture group ( (?:) ) that matches one of the optional markers: פ, ס, or ש, each preceded by a space character. The ? at the end makes this group optional, so it will still match if the marker is not present.

# The (?:) syntax is called a non-capture group or a passive group. It groups the alternatives together, but it doesn't create a capture group, which means it won't be included in the match array.

# def hebrew_to_numerical(hebrew_string)
#   hebrew_chars = 'אבגדהוזחטיכלמנסעפצקרשת'
#   values = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 200, 300, 400]
#   hebrew_string.split('').map { |char|
#     index = hebrew_chars.index(char)
#     values[index]
#   }.sum
# end

# def chapter_verse(html)
#   chapter_verse_regex = /\b(א,[א-ת]+)\b/
#   chapter_verse_matches = html.css('p').map { |p|
#     p.text.scan(chapter_verse_regex).flatten
#   }.compact
#   puts "Chapter verse matches: #{chapter_verse_matches.inspect}"
#   chapter_verse_matches
# end

# def chapter_verse_numerical(chapter_verse_matches)
#   numerical = chapter_verse_matches.map { |chapter_verse|
#     next if chapter_verse.empty?

#     parts = chapter_verse[0].split(',')
#     next if parts.size != 2

#     chapter_numerical = hebrew_to_numerical(parts[0])
#     verse_numerical = hebrew_to_numerical(parts[1])
#     [chapter_numerical, verse_numerical]
#   }
#   numerical
# end

# def extract_verse_text(html)
#   verse_text_regex = /\b(א,[א-ת]+)\b(.*)/
#   verse_texts = html.css('p').map { |p|
#     p.text.scan(verse_text_regex).flatten
#   }.compact
#   verse_texts
# end

# def data_hashes(numerical, verse_texts)
#   data = []
#   numerical.zip(verse_texts).each { |chapter_verse, verse_text|
#     puts "chapter_verse: #{chapter_verse.inspect}" # add this line
#     next if chapter_verse.nil? || chapter_verse.empty? || chapter_verse.any?(&:nil?) # skip empty or nil-containing arrays

#     if chapter_verse[0].is_a?(String)
#       chapter_number, verse_number = chapter_verse[0].split(',').map(&:to_i)
#     else
#       next
#     end
    
#     data << { 
#       chapter: chapter_number, 
#       verse_number: verse_number, 
#       verse_text: verse_text[1] 
#     }
#   }
#   pp data
#   data
# end

# def seed_data(data)
#   data.each { |entry|
#     Verse.create!(
#       chapter: entry[:chapter],
#       verse_number: entry[:verse_number],
#       verse_text: entry[:verse_text]
#       )
#   }
# end

# def main
#   file_path = File.join(Rails.root, '..', 'Tanach_Text', 'k001', 'k', 'k01.htm')
#   html = File.open(file_path) { |f| Nokogiri::HTML(f) }
#   chapter_verse_matches = chapter_verse(html)
#   numerical = chapter_verse_numerical(chapter_verse_matches)
#   verse_texts = extract_verse_text(html)
#   seed_data(data_hashes(numerical, verse_texts))
# end

# main