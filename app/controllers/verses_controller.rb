class VersesController < ApplicationController
  def index
    verses = Verse.order(:id).all
    render json: verses
  end

  def show
    if params[:chapter] && params[:verse]
      # Code block for verses/chapter/verse
      chapter = params[:chapter].to_i
      verse_number = params[:verse].to_i
      verse = Verse.find_by(chapter: chapter)
    else
      # Code block for verses/id
      verse = Verse.find(params[:id])
    end
    render json: verse, include: :words
  end
end
