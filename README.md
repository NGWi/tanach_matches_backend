# Tanach Matches Backend

![Filled Matches Table](./public/Screenshot.png)

## Overview

Tanach Matches is a full-stack application that allows users to instantly find all matches for words in the Tanach (Ancient Hebrew Bible), where the word appears at least as part of the "matched word." This application backend is built using Ruby on Rails and provides APIs for fetching verses, words, matches, and their associated data.

I built an associated frontend using React. It can be found @ [https://github.com/NGWi/tanach_matches_frontend](https://github.com/NGWi/tanach_matches_frontend).

Please note that this is a work in progress. Items parenthesized and italicized below _(like this)_ are currently in the midst of development.

Also note that, so far, it has only been built to handle files with the format of the Tanach @ [https://mechon-mamre.org/i/t/x/x0.htm](https://mechon-mamre.org/), e.g., [https://mechon-mamre.org/i/t/x/x01.htm](https://mechon-mamre.org/i/t/x/x01.htm)

A list of planned features for the project can be found @ [https://gist.github.com/NGWi/21a69a3a859f619e49eb25dc1c87a725](https://gist.github.com/NGWi/21a69a3a859f619e49eb25dc1c87a725)

## Features

- List all verses in order with their book, chapter, and verse number
- Zoom in on a specific verse to see all its words with their associated data
- Fetch a word and all its connected data
- Retrieve matches for words
- Fetch matched words and their associated verses
- _(Go directly to verses by chapter and verse number)_

## Installation

Prerequisites: Ruby, Ruby on Rails, and PostgreSQL.

To get started with the Tanach Matches backend, follow these steps:

1. Clone the repository: `git clone https://github.com/your-username/tanach-matches-backend.git`
2. Install dependencies: `bundle install`
3. Delete config/credentials.yml.enc. Then run `rails credentials:edit`, which will create a new key and encrypted credentials file.
4. Set up the database: `rails db:create` and `rails db:migrate`
5. Upload a document to the database: Place it in the `db/raw_htm_text` folder, and replace the current file_name at the beginning of `db/seeds.rb` with the name of the document. Then run `rails db:seed`
6. Start the server: `rails server`

## Usage

The backend provides the following APIs for interacting with the data:

- ### Route 1: Fetch all verses (index without nested data)

  GET '/verses'

- ### Route 2: Fetch one verse (show verse with nested word data)

  GET '/verses/:id'

- ### Route 3: Fetch one word (show word with nested matches)

  GET '/words/:id'

- _(Route 4: Fetch a verse by chapter and verse number
  GET '/verses/:chapter/:verse')_

## Contributing

Contributions are welcome! If you find any bugs or have ideas for new features, please open an issue or submit a pull request.

## License

This project is licensed under the MIT License.
