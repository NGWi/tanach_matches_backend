class WordsController < ApplicationController
  def show
    word = Word.find(params[:id])
    render json: word.as_json( include: { verse: { only: [:book, :chapter, :verse_number] }, 
                                         matches: { only: [:id, :matched_word_id], 
                                                  include: { matched_word: { only: [:id, :text, :verse_id], include: { verse: { } } }  
                                                            }  
                                                    } 
                                          } 
                              )
  end
end
