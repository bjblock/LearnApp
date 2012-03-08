require "csv"
require 'rubygems'
require 'roo'
require 'zip/zipfilesystem'
require 'spreadsheet'

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

  def rooparse(oo)
    
     @answers = Array.new
     @questions = Array.new
  
    oo.default_sheet = oo.sheets.first
    
    1.upto(oo.last_row) do |row|
      newa = Answer.create(:content => oo.cell(row,'B'))
      newq = Question.create(:content => oo.cell(row,'A'), :correct_answer_id => newa.id, :deck_id => @deck.id)
    
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

        format.html {return render action: "new", notice: "Error! #{e.message}", status: :unprocessable_entity
                }
      end
  
  # changed from redirect_to @deck
  #redirect_to root_path, notice: @deckmsg

  end

  def edit
    @deck = Deck.find(params[:id])
  end

  # POST /decks
  # POST /decks.json
  def create
    require 'fileutils'
    require 'iconv'
    
     @deck = Deck.new
     @deck.name = params[:uploadform][:name]
     @deckmsg = ""
     @filename = params[:uploadform][:file].original_filename
     tmp = params[:uploadform][:file].tempfile
     file = File.join("public", params[:uploadform][:file].original_filename)
     FileUtils.cp tmp.path, file
      
     if @deck.save
       @deckmsg='Deck was successfully created.'
     else
       respond_to do |format|
         format.html { render action: "new", notice: 'Deck was not created.' }
       end
     end
  
  # case function to use different parsing depending on file extension
  # google spreadsheet still left out
  # if params[:uploadform][:file] =~ (?<=[\\/])[\w\.]{3,28}\.(?:pdf|txt|doc|docx|png|gif|jpeg|jpg|zip|rar)$
  # if params[:uploadform][:file].extname == "csv"
    
     if @filename =~ /.*\.csv$/i
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
              #debugger
              format.html {return render root_url, notice: "Error! #{e.message}", status: :unprocessable_entity
                          }
            end
          
          redirect_to @deck, notice: @deckmsg
        end
     end
     
     if params[:uploadform][:file].original_filename =~ /.*\.xlsx$/i
             oo = Excelx.new(file)

             rooparse(oo)
             FileUtils.rm file
             redirect_to new_deck_url, notice: "Deck successfully created!"
         end
    if params[:uploadform][:file].original_filename =~ /.*\.xls$/i
            oo = Excel.new(file)
           
            rooparse(oo)
            FileUtils.rm file
            redirect_to new_deck_url, notice: "Deck successfully created!"
        end
    
        if params[:uploadform][:file].original_filename =~ /.*\.ods$/i
                oo = Openoffice.new(file)

                rooparse(oo)
                FileUtils.rm file
                redirect_to new_deck_url, notice: "Deck successfully created!"
            end


    # 
    # # files without a . should be a google spreadsheet key
    #   when params[:uploadform][:file] =~ /^[a-zA-Z\d\s]*$/ then
    #     oo = Google.new("myspreadsheetkey_at_google")
    #   
    #     rooparse(oo)
    # 
    #   else
    #   # render new again with invalid file name or google id notice
    # 
    

  
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
