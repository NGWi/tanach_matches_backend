class WordsController < ApplicationController
  def show
    word = Word.find(params[:id])
    render json: word.as_json( include: { verse: { only: [:chapter, :verse_number] }, 
                                         matches: { only: [:id, :matched_word_id], 
                                                  include: { matched_word: { only: [:id, :text, :verse_id] } 
                                                            }  
                                                    } 
                                          } 
                              )
  end
end
