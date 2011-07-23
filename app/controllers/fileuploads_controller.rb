class FileuploadsController < ApplicationController
  # GET /fileuploads
  # GET /fileuploads.xml
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

    @fileuploads = Fileupload.find_by_sql("Select * from fileuploads where username='#{session[:username]}' order by updated_at desc")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @fileuploads }
    end
  end

  # GET /fileuploads/1
  # GET /fileuploads/1.xml
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
    @fileupload = Fileupload.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @fileupload }
    end
  end

  # GET /fileuploads/new
  # GET /fileuploads/new.xml
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
      @notice='new'
    @fileupload = Fileupload.new


    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @fileupload }
    end
  end

  # GET /fileuploads/1/edit
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
      @notice='edit'
    @fileupload = Fileupload.find(params[:id])
  end

  # POST /fileuploads
  # POST /fileuploads.xml
  def create
    @fileupload = Fileupload.new(params[:fileupload])
    @fileupload.username=session[:username]
    extensions=[".doc",".docx",".ppt",".pptx",".xls",".xlsx",".txt",".rtf",".odt", ".ott",".oth",".odm",".pdf"]
    count=0
    flag=false
    if(@fileupload.filename)
      while(count<=12)
        if(File.extname(@fileupload.filename)==extensions[count])
          flag=true
          break
        end
        count=count+1
      end
      if(flag==false)
        redirect_to "/fileuploads/new", :notice => 'Invalid file extension' and return
      end
    end
     exist=Fileupload.find_by_sql("Select * from fileuploads where filename='#{@fileupload.filename}' and username='#{session[:username]}'")
      if(exist[0])
        redirect_to "/fileuploads/new", :notice => 'File already Exists' and return
      end 
      @fileupload.created_at=Time.now+5.hours+30.minutes
          @fileupload.updated_at=Time.now+5.hours+30.minutes
          
    respond_to do |format|

     
      if @fileupload.save
          @fileupload.save_file(session[:username])
          
          format.html { redirect_to(@fileupload, :notice => 'File was successfully uploaded') }
          format.xml  { render :xml => @fileupload, :status => :created, :location => @fileupload }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @fileupload.errors, :status => :unprocessable_entity }
      end
    end
      
  end

  # PUT /fileuploads/1
  # PUT /fileuploads/1.xml
  def update
    @fileupload = Fileupload.find(params[:id])
    @s=session[:username]+'_'+@fileupload.filename
    @fileupload.updated_at=Time.now+5.hours+30.minutes
      respond_to do |format|
      if @fileupload.update_attributes(params[:fileupload])
         
          
        format.html { redirect_to(@fileupload, :notice => 'File Details were successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @fileupload.errors, :status => :unprocessable_entity }
      end
      end
  end

  # DELETE /fileuploads/1
  # DELETE /fileuploads/1.xml
  def destroy
    @fileupload = Fileupload.find(params[:id])

    File.delete("#{RAILS_ROOT}/public/files/#{@fileupload.username+'_'+@fileupload.filename}")
    @fileupload.destroy

    respond_to do |format|
      format.html { redirect_to(fileuploads_url) }
      format.xml  { head :ok }
    end
  end
  def allfileuploads
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
    if(params[:list]=='username')
     @fileuploads = Fileupload.find_by_sql("Select * from fileuploads where fvisible='shared' and username like '%#{params[:search]}%' order by updated_at desc")
    elsif(params[:list]=='title')
     @fileuploads = Fileupload.find_by_sql("Select * from fileuploads where fvisible='shared' and title like '%#{params[:search]}%' order by updated_at desc")  
    elsif(params[:list]=='keywords')
     @fileuploads = Fileupload.find_by_sql("Select * from fileuploads where fvisible='shared' and keywords like '%#{params[:search]}%' order by updated_at desc")
    elsif(params[:list]=='duration')
      @fileuploads = Fileupload.find_by_sql("Select * from fileuploads where fvisible='shared' and updated_at between '#{params[:search]}' and date_add('#{params[:duration]}',INTERVAL 1 day)  order by updated_at desc")
    elsif(params[:list]=='all')
      @fileuploads = Fileupload.find_by_sql("Select * from fileuploads where fvisible='shared' order by updated_at desc")
    end
  end
end
