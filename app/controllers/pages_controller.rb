class PagesController < ApplicationController
  def index
    session[:current_q] = nil
    session[:the_deck] = nil
    render :layout => 'custom'
  end
  
  def quiz
    redirect_to deck_path(params[:deckselect][:id])
  end
  
end
