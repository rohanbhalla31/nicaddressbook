class Tasklist < ActiveRecord::Base
   LIST=['Low','Medium','High']
  NAMELIST=Addressbook.find_by_sql("Select name from addressbooks order by name")
  i=0
  NAMELIST.each do |f|
    NAMELIST[i]=NAMELIST[i].name.titlecase
    i=i+1
  end
  TYPE=Tasktype.find_by_sql("Select tasktype from tasktypes")
   i=0
  TYPE.each do |f|
    TYPE[i]=TYPE[i].tasktype.titlecase
    i=i+1
  end
   validates_presence_of:subject,:message => "Error!! Enter Subject"
   validates_presence_of:startdate,:message => "Error!! Invalid Start Date"
   validates_presence_of:targetdate,:message => "Error!! Invalid Target Date"
   validate :start_must_be_before_end_date

  def start_must_be_before_end_date
    if(startdate)
    errors.add(:startdate, "must be before Target date") unless
       startdate <= targetdate
    end
  end

    def load_file=(data)
     self.filename = data.original_filename
     @file_data = data
   end

   def save_file(s)
     path="/public/tasks"
       self.filename = s+'_'+self.filename

       name = File.join RAILS_ROOT, path, self.filename
       File.open(name, 'wb') do |f|
         f.write(@file_data.read)

       @file_data = nil
       end
   end
end
