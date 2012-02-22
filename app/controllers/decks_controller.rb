require "csv"

class DecksController < ApplicationController

  def index
    @decks = Deck.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @decks }
    end
  end

  # GET /decks/1
  # GET /decks/1.json
def show
   if session[:the_deck].present?
     
      @deck = Deck.find(session[:the_deck])
      
      @question = Question.find(session[:current_q])
    
      @question = @question.next
      
      if @question.blank?
        flash[:notice] = "You finished this Deck!"
        redirect_to root_url
      else
        
        session[:current_q] = @question.id
      
        @quiz = Array.new
        
     
        wrong_answers = @question.answers
        wrong_answers = wrong_answers.shuffle!
        @quiz << wrong_answers.first
        @quiz << wrong_answers.second
        @quiz << wrong_answers.third
        
        @quiz << @question.answer
        
        respond_to do |format|
          format.html # show.html.erb
          format.json { render json: @deck }
        end
      end
      
   else
     
    @deck = Deck.find(params[:id])
    session[:the_deck] = @deck.id
    session[:current_q] = @deck.questions.first.id
    
    @question = @deck.questions.first

    @quiz = Array.new
      
    wrong_answers = @question.answers
    wrong_answers = wrong_answers.shuffle!
    @quiz << wrong_answers.first
    @quiz << wrong_answers.second
    @quiz << wrong_answers.third
      
      # FJ: Version with all Answers as choices
      # @question.answers.each do |answer|
      #   @quiz << answer
      # end

    @quiz << @question.answer

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @deck }
    end
  end
end
  
  
def check
  @question = Question.find(params[:qid])
    
  @answer = params[:aid]
    
  if @question.correct_answer_id == @answer.to_i
    flash[:notice] = "Correct!"  
  else
    flash[:notice] = "Wrong!"
  end
    
  redirect_to question_url(@question)
   
end

def new
  @deck = Deck.new

  respond_to do |format|
    format.html # new.html.erb
    format.json { render json: @deck }
  end
end

def edit
  @deck = Deck.find(params[:id])
end

  # POST /decks
  # POST /decks.json
  def create
     @deck = Deck.new
    @deck.name = params[:uploadform][:name]
      @deckmsg = ""
      
        if @deck.save
          
          @deckmsg='Deck was successfully created.'
        else
          
       respond_to do |format|
           format.html { render action: "new", notice: 'Deck was not created.' }
       end
     end
       
       
        begin
           @answers = Array.new
           @questions = Array.new
    
           CSV.parse(params[:uploadform][:file].read) do |row|  
                newa = Answer.create(:content => row[1])
                newq = Question.create(:content => row[0], :correct_answer_id => newa.id, :deck_id => @deck.id)
    
                @answers    << newa
                @questions  << newq
            end
    
            @questions.each do |question|
                @answers.each do |answer|
                    if question.correct_answer_id != answer.id
                        Choice.create(:question_id => question.id, :answer_id => answer.id)
                    end
                end
            end
    
         rescue Exception => e
           respond_to do |format|
             debugger
             format.html {return render action: "new", notice: "Error! #{e.message}", status: :unprocessable_entity
                          }
           end
         end
          redirect_to @deck, notice: @deckmsg
    
       
 
  end

  # PUT /decks/1
  # PUT /decks/1.json
  def update
    @deck = Deck.find(params[:id])

    respond_to do |format|
      if @deck.update_attributes(params[:deck])
        format.html { redirect_to @deck, notice: 'Deck was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @deck.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /decks/1
  # DELETE /decks/1.json
  def destroy
    @deck = Deck.find(params[:id])
    @deck.destroy

    respond_to do |format|
      format.html { redirect_to decks_url }
      format.json { head :no_content }
    end
  end
end
