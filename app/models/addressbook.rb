class Addressbook < ActiveRecord::Base
  validates_format_of:name,:with=>/[a-zA-Z]/,:message => "Error!! Invalid Name [A-Z] or [a-z] allowed only"
    validates_presence_of:phoneno,:message => "Error!! Enter Phone No"
    validates_presence_of:username,:message => "Error!! Enter Username"
    validates_presence_of:designation,:message => "Error!! Enter Designation"

    validates_presence_of:role,:message => "Error!! Select a Role"

    validates_length_of:password,:minimum=>6,:message => "Error!! Invalid Password Min 6 characters long",:confirmaton=>true
   
    
    validates_uniqueness_of:username,:case_sensitive => false,:message=>"Error!! Username Already Exists"
    validates_uniqueness_of:email,:case_sensitive => false,:message=>"Error!! E-mail Already Exists"
     validates_format_of :email,:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  
  LIST=["administrator","user"]
 
   attr_accessor :password_confirmation 
    validates_confirmation_of :password
     validates_presence_of :password_confirmation
   require 'digest/sha1'

attr_accessor :password_confirmation,:password

#password is virtual attribute
def password
@password
end

def password=(pwd)
@password = pwd
return if pwd.blank?
create_new_salt #call create_new_salt method
self.hashed_password = Addressbook.encrypted_password(self.password, self.salt)
end




def self.authenticate(name, password)
addressbook =Addressbook.find_by_username(name)
if addressbook
expected_password = encrypted_password(password, addressbook.salt)
if addressbook.hashed_password != expected_password
addressbook = nil
end
end
addressbook
end

  def send_new_password
   new_pass = Addressbook.random_string(7)
   self.password = self.password_confirmation = new_pass
   self.save
   Addressbookmailer.password_recovery(self.email, self.username, new_pass).deliver
  end

  def self.random_string(len)

   chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
   newpass = ""
   1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
   return newpass
 end


private


def create_new_salt # it stores salt value
self.salt = self.object_id.to_s + rand.to_s
# take password object id and concate random value
end

def self.encrypted_password(password, salt)
string_to_hash = password + "wibble" + salt
Digest::SHA1.hexdigest(string_to_hash)
end

def password_non_blank
errors.add(:password,"Missing password")if hashed_password.blank?
end
  end
  