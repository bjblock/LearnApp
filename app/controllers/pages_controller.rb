class PagesController < ApplicationController
  def index
  end
  
  def quiz
    redirect_to deck_path(params[:deckselect][:id])
  end
  
end
