class VersesController < ApplicationController
  def index
    verses = Verse.order(:id).all
    render json: verses
  end

  def show
    if params[:id] # That the GET route matches '/verses/x' with no '/y' afterwards.
      verse = Verse.find(params[:id])
    else
      chapter = params[:chapter].to_i
      verse_number = params[:verse].to_i
      verse = Verse.find_by(chapter: chapter, verse_number: verse_number)
    end
    render json: verse, include: {
      words: {
        include: {
          matches: {
            only: [:matched_word_id],
            include: {
              matched_word: {
                only: [:text],
                include: { verse: { only: [:text] } }
              }
            }
          }
        }
      }
    }
  end
end
