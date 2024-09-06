class VersesController < ApplicationController
  def index
    verses = Verse.all
    render json: verses
  end

  def show
    if params[:id]
      verse = Verse.find(params[:id])
    else
      chapter = params[:chapter].to_i
      verse_number = params[:verse].to_i
      verse = Verse.find_by(chapter: chapter, verse_number: verse_number)
    end
    render json: verse, include: [:words]
  end
end
