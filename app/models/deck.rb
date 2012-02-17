class Deck < ActiveRecord::Base
  
  has_many :questions
  
end
