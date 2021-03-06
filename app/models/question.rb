class Question < ActiveRecord::Base
  
  has_many :choices
  
  belongs_to :deck
  
  belongs_to :answer, :foreign_key => "correct_answer_id"
  
  has_many :answers, :through => :choices
  
  def next
    self.class.find(:first, :conditions => ["id > ?",id])
  end
  
end
