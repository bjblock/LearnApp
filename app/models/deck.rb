class Deck < ActiveRecord::Base
  
  has_many :questions
  
  def next
    self.class.find(:first, :conditions => ["id > ?",self.id])
  end
  
end
