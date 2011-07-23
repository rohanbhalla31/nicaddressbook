class Visitor < ActiveRecord::Base
  validates_presence_of:name,:message => "Error!! Enter Name"

 


end
