class VersesController < ApplicationController
  def index
    verses = Verse.order(:id).all
    render json: verses
  end

  def show
    if params[:chapter] && params[:verse]
      # Code block for verses/1/1
      chapter = params[:chapter].to_i
      verse_number = params[:verse].to_i
      verse = Verse.find_by(chapter: chapter)
    else
      # Code block for verses/1
      verse = Verse.find(params[:id])
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
    }, except: [:book]
  end
end
