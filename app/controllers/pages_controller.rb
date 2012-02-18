class PagesController < ApplicationController
  def index
    reset_session
  end
  
  def quiz
    redirect_to deck_path(params[:deckselect][:id])
  end
  
end
