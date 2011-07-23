class TasklistsController < ApplicationController
  # GET /tasklists
  # GET /tasklists.xml
  def index
     if(!session[:username] or session[:role]=='administrator')
      redirect_to "/addressbooks/login" and return
    end
      if(Time.now-1.hours>session[:time].to_time)
        redirect_to "/addressbooks/logout",:notice=>"Session expired" and return
      else
        session[:time]=Time.now
      end
     s=Addressbook.find_by_username(session[:username])
    @name=s.name.titlecase
     if(params[:list]=="id")
        @tasklists = Tasklist.find_by_sql("Select * from tasklists where assignedto='#{session[:username]}' order by id")
      elsif(params[:list]=="subject")
        @tasklists = Tasklist.find_by_sql("Select * from tasklists where assignedto='#{session[:username]}' order by subject")
      elsif(params[:list]=="startedon")
        @tasklists = Tasklist.find_by_sql("Select * from tasklists where assignedto='#{session[:username]}' order by startdate")
      elsif(params[:list]=="targetdate")
        @tasklists = Tasklist.find_by_sql("Select * from tasklists where assignedto='#{session[:username]}' order by targetdate")
      elsif(params[:list]=="priority")
        @tasklists = Tasklist.find_by_sql("Select * from tasklists where assignedto='#{session[:username]}' order by priority")
      elsif(params[:list]=="status")
        @tasklists = Tasklist.find_by_sql("Select * from tasklists where assignedto='#{session[:username]}' order by currentstatus")
      else
        @tasklists = Tasklist.find_by_sql("Select * from tasklists where assignedto='#{session[:username]}'")
      end

     if(params[:list1]=="id")
        @tasklists1 = Tasklist.find_by_sql("Select * from tasklists where username='#{session[:username]}' and assignedto  !='#{session[:username]}'  order by id")
      elsif(params[:list1]=="subject")
        @tasklists1 = Tasklist.find_by_sql("Select * from tasklists where username='#{session[:username]}' and assignedto  !='#{session[:username]}' order by subject")
      elsif(params[:list1]=="startedon")
        @tasklists1 = Tasklist.find_by_sql("Select * from tasklists where username='#{session[:username]}' and assignedto  !='#{session[:username]}' order by startdate")
      elsif(params[:list1]=="targetdate")
        @tasklists1 = Tasklist.find_by_sql("Select * from tasklists where username='#{session[:username]}' and assignedto  !='#{session[:username]}' order by targetdate")
      elsif(params[:list1]=="priority")
        @tasklists1 = Tasklist.find_by_sql("Select * from tasklists where username='#{session[:username]}' and assignedto  !='#{session[:username]}' order by priority")
      elsif(params[:list1]=="assignedto")
       @tasklists1 = Tasklist.find_by_sql("Select * from tasklists where username='#{session[:username]}' and assignedto  !='#{session[:username]}' order by assignedto ")
      elsif(params[:list]=="status")
        @tasklists1 = Tasklist.find_by_sql("Select * from tasklists where username='#{session[:username]}'  and assignedto  !='#{session[:username]}' order by currentstatus")
      else
        @tasklists1 = Tasklist.find_by_sql("Select * from tasklists where username='#{session[:username]}' and assignedto  !='#{session[:username]}'")
      end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tasklists }
    end
  end

  # GET /tasklists/1
  # GET /tasklists/1.xml
  def show
     if(!session[:username] or session[:role]=='administrator')
      redirect_to "/addressbooks/login" and return
    end
      if(Time.now-1.hours>session[:time].to_time)
        redirect_to "/addressbooks/logout",:notice=>"Session expired" and return
      else
        session[:time]=Time.now
      end
    s=Addressbook.find_by_username(session[:username])
    @name=s.name.titlecase
    @tasklist = Tasklist.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tasklist }
    end
  end

  # GET /tasklists/new
  # GET /tasklists/new.xml
  def new
     if(!session[:username] or session[:role]=='administrator')
      redirect_to "/addressbooks/login" and return
    end
      if(Time.now-1.hours>session[:time].to_time)
        redirect_to "/addressbooks/logout",:notice=>"Session expired" and return
      else
        session[:time]=Time.now
      end
    s=Addressbook.find_by_username(session[:username])
    @name=s.name.titlecase
    @tasklist = Tasklist.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tasklist }
    end
  end

  # GET /tasklists/1/edit
  def edit
     if(!session[:username] or session[:role]=='administrator')
      redirect_to "/addressbooks/login" and return
    end
      if(Time.now-1.hours>session[:time].to_time)
        redirect_to "/addressbooks/logout",:notice=>"Session expired" and return
      else
        session[:time]=Time.now
      end
      s=Addressbook.find_by_username(session[:username])
    @name=s.name.titlecase
    @tasklist = Tasklist.find(params[:id])
  end

  # POST /tasklists
  # POST /tasklists.xml
  def create
    @tasklist = Tasklist.new(params[:tasklist])
    @tasklist.username=session[:username]
    extensions=[".doc",".docx",".ppt",".pptx",".xls",".xlsx",".txt",".rtf",".odt", ".ott",".oth",".odm",".pdf"]
    count=0
    flag=false
    if(@tasklist.filename)
      while(count<=12)
        if(File.extname(@tasklist.filename)==extensions[count])
          flag=true
          break
        end
        count=count+1
      end
      if(flag==false)
        redirect_to "/tasklists/new", :notice => 'Invalid file extension' and return
      end
    end
    if(@tasklist.assignedto!="")
     t=Addressbook.find_by_name(@tasklist.assignedto)
     @tasklist.assignedto=t.username
    end
    @tasklist.created_at=Time.now+5.hours+30.minutes
    @tasklist.updated_at=Time.now+5.hours+30.minutes
    exist=Tasklist.find_by_sql("Select * from tasklists where filename='#{@tasklist.filename}' and username='#{session[:username]}'")
      if(exist[0])
         redirect_to "/tasklists/new", :notice => 'File already Exists' and return
      end

    respond_to do |format|
      if @tasklist.save
        if(@tasklist.filename)
          @tasklist.save_file(session[:username])
        end
        format.html { redirect_to(@tasklist, :notice => 'Tasklist was successfully created.') }
        format.xml  { render :xml => @tasklist, :status => :created, :location => @tasklist }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tasklist.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tasklists/1
  # PUT /tasklists/1.xml
  def update

    @tasklist = Tasklist.find(params[:id])

    @tasklist.updated_at=Time.now+5.hours+30.minutes
    respond_to do |format|
      if @tasklist.update_attributes(params[:tasklist])
        if(@tasklist.assignedto!="")
         t=Addressbook.find_by_name(@tasklist.assignedto)
         @tasklist.assignedto=t.username
         @tasklist.update_attributes(@tasklist.assignedto)
        end
        format.html { redirect_to(@tasklist, :notice => 'Task was successfully created') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tasklist.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tasklists/1
  # DELETE /tasklists/1.xml
  def destroy
     if(!session[:username] or session[:role]=='administrator')
      redirect_to "/addressbooks/login" and return
    end
      if(Time.now-1.hours>session[:time].to_time)
        redirect_to "/addressbooks/logout",:notice=>"Session expired" and return
      else
        session[:time]=Time.now
      end
    @tasklist = Tasklist.find(params[:id])
     if(@tasklist.filename)
       File.delete("#{RAILS_ROOT}/public/tasks/#{@tasklist.username+'_'+@tasklist.filename}")
     end
    @tasklist.destroy

    respond_to do |format|
      format.html { redirect_to(tasklists_url) }
      format.xml  { head :ok }
    end
  end

  def alltasks
     if(!session[:username] or session[:role]=='administrator')
      redirect_to "/addressbooks/login" and return
     end
      if(Time.now-1.hours>session[:time].to_time)
        redirect_to "/addressbooks/logout",:notice=>"Session expired" and return
      else
        session[:time]=Time.now
      end
    s=Addressbook.find_by_username(session[:username])
    @name=s.name.titlecase
     if(params[:list]=="id")
        @tasklists = Tasklist.find_by_sql("Select * from tasklists where tvisible='shared' and id='#{params[:search]}' order by id")
      elsif(params[:list]=="subject")
        @tasklists = Tasklist.find_by_sql("Select * from tasklists where tvisible='shared' and subject like '%#{params[:search]}%' order by subject")
      elsif(params[:list]=="startedon")
        @tasklists = Tasklist.find_by_sql("Select * from tasklists where tvisible='shared' and stratedon='#{params[:search]}' order by startdate")
      elsif(params[:list]=="targetdate")
        @tasklists = Tasklist.find_by_sql("Select * from tasklists where tvisible='shared' and targetdate='#{params[:search]}' order by targetdate")
      elsif(params[:list]=="priority")
        @tasklists = Tasklist.find_by_sql("Select * from tasklists where tvisible='shared' and priority like '%#{params[:search]}%' order by priority")
      elsif(params[:list]=="assignedto")
       @tasklists = Tasklist.find_by_sql("Select * from tasklists where tvisible='shared' and assignedto like '%#{params[:search]}%' order by assignedto")
      elsif(params[:list]=="status")
       @tasklists = Tasklist.find_by_sql("Select * from tasklists where tvisible='shared' and currentstatus like '%#{params[:search]}%' order by currentstatus")
      else
        @tasklists = Tasklist.find_by_sql("Select * from tasklists where tvisible='shared'")
      end
  end
end
