class Fileupload < ActiveRecord::Base
   validates_presence_of :filename,:message=>"Error!! Upload a Document"
   validates_presence_of :title,:message=>"Error!! Enter Subject"
   validates_length_of :keywords,:maximum=>500,:message => "Error!! Max 500 characters",:confirmaton=>true
   def load_file=(data)

     self.filename = data.original_filename
     @file_data = data
   end

   def save_file(s)
     path="/public/files"
       self.filename = s+'_'+self.filename

       name = File.join RAILS_ROOT, path, self.filename
       File.open(name, 'wb') do |f|
         f.write(@file_data.read)

       @file_data = nil
     end
   end
end
