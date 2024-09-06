class WordsController < ApplicationController
  def show
    word = Word.find(params[:id])
    render json: word.as_json(include: { matches: { only: [:id, :matched_word_id], include: { matched_word: { include: { verse: { only: [:chapter, :verse_number] } } } } } })
  end
end
