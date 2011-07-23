class AddressbooksController < ApplicationController
  # GET /addressbooks
  # GET /addressbooks.xml
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
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @addressbooks }
    end
  end

  # GET /addressbooks/1
  # GET /addressbooks/1.xml
  def show
    if(!session[:username])
      redirect_to "/addressbooks/login" and return
    end
    if(Time.now-1.hours>session[:time].to_time)
        redirect_to "/addressbooks/logout",:notice=>"Session expired" and return
      else
        session[:time]=Time.now
    end
     s=Addressbook.find_by_username(session[:username])
    @name=s.name.titlecase
   @addressbook=Addressbook.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @addressbook }
    end
  end

  # GET /addressbooks/new
  # GET /addressbooks/new.xml
  def new
 if(session[:role]!='administrator' or !session[:username])
      redirect_to "/addressbooks/login" and return
    end
     if(Time.now-1.hours>session[:time].to_time)
        redirect_to "/addressbooks/logout",:notice=>"Session expired" and return
      else
        session[:time]=Time.now
      end
       s=Addressbook.find_by_username(session[:username])
    @name=s.name.titlecase
    @addressbook = Addressbook.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @addressbook }
    end
  end

  # GET /addressbooks/1/edit
  def edit
    if(!session[:username])
      redirect_to "/addressbooks/login" and return
    end
    if(Time.now-1.hours>session[:time].to_time)
        redirect_to "/addressbooks/logout",:notice=>"Session expired" and return
      else
        session[:time]=Time.now
    end
     s=Addressbook.find_by_username(session[:username])
    @name=s.name.titlecase
    @addressbook = Addressbook.find(params[:id])
  end

  # POST /addressbooks
  # POST /addressbooks.xml
  def create
    @addressbook = Addressbook.new(params[:addressbook])
    @addressbook.name=@addressbook.name.downcase
    @addressbook.username=@addressbook.username.downcase

    @addressbook.created_at=Time.now+5.hours+30.minutes
    @addressbook.updated_at=Time.now+5.hours+30.minutes
    respond_to do |format|
      if @addressbook.save
        Addressbookmailer.registration_confirmation(@addressbook).deliver
        format.html { redirect_to(@addressbook, :notice => 'Employee Details were successfully added.') }
        format.xml  { render :xml => @addressbook, :status => :created, :location => @addressbook }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @addressbook.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /addressbooks/1
  # PUT /addressbooks/1.xml
  def update
    @addressbook = Addressbook.find(params[:id])
     if(Time.now-1.hours>session[:time].to_time)
        redirect_to "/addressbooks/logout",:notice=>"Session expired" and return
      else
        session[:time]=Time.now
      end
      @addressbook.updated_at=Time.now+5.hours+30.minutes
    respond_to do |format|
      if @addressbook.update_attributes(params[:addressbook])
        format.html { redirect_to(@addressbook, :notice => 'Addressbook was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @addressbook.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /addressbooks/1
  # DELETE /addressbooks/1.xml
  def destroy
    if(session[:role]!='administrator' or !session[:username])
      redirect_to "/addressbooks/login" and return
    end
     if(Time.now-1.hours>session[:time].to_time)
        redirect_to "/addressbooks/logout",:notice=>"Session expired" and return
      else
        session[:time]=Time.now
      end
    @visitor=Visitor.new
    @addressbook = Addressbook.find(params[:id])
    @visitor=Visitor.find_all_by_username(@addressbook.username)
    @visitor.each do |f|
      f.destroy
    end
    @fileupload=Fileupload.find_all_by_username(@addressbook.username)
    @fileupload.each do |f|
      File.delete("#{RAILS_ROOT}/public/files/#{f.username+'_'+f.filename}")
      f.destroy
    end
    @tasklist=Tasklist.find_all_by_username(@addressbook.username)
    @tasklist.each do |f|
      if(f.filename)
       File.delete("#{RAILS_ROOT}/public/tasks/#{f.username+'_'+f.filename}")
      end
      f.destroy
    end
    @addressbook.destroy

    respond_to do |format|
      format.html { redirect_to("/addressbooks/homeadmin") }
      format.xml  { head :ok }
    end
  end
  def home
    addressbooks=Addressbook.new
    addressbooks=Addressbook.find_by_sql("Select role from addressbooks where username='#{params[:username]}'")
      if(!addressbooks[0])
        redirect_to "/addressbooks/login",:notice=>"Invalid username" and return
      elsif(Addressbook.authenticate(params[:username],params[:password]) and (params[:role]=='administrator') and (addressbooks[0].role=='administrator'))
        session[:username]=params[:username]
        session[:role]=params[:role]
        session[:time]=Time.now
        redirect_to "/addressbooks/homeadmin" and return
      elsif(Addressbook.authenticate(params[:username],params[:password]) and params[:role]=='user' )
        session[:username]=params[:username]
        session[:role]=params[:role]
        session[:time]=Time.now
        redirect_to "/addressbooks" and return
      else
        redirect_to "/addressbooks/login",:notice=>"Invalid password or role" and return
      end
  end

  def logout
    session[:username]=nil
    session[:role]=nil
    session[:time]=nil
  end

  def search
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
    @visitors= Visitor.new
    if(params[:list]=="name")
      @visitors = Visitor.find_by_sql("Select * from visitors where name like '%#{params[:search]}%' and visible='shared'")
    elsif(params[:list]=="officer")
       @visitors = Visitor.find_by_sql("Select * from visitors where officer like '%#{params[:search]}%' and visible='shared'")
    elsif(params[:list]=="company")
       @visitors = Visitor.find_by_sql("Select * from visitors where company like '%#{params[:search]}%' and visible='shared'")
    else
        @visitors = Visitor.find_by_sql("Select * from visitors where visible='shared'")
    end
  end

  def homeadmin
    if(session[:role]=='administrator')
      if(Time.now-1.hours>session[:time].to_time)
        redirect_to "/addressbooks/logout",:notice=>"Session expired" and return
      else
        session[:time]=Time.now
      end
       s=Addressbook.find_by_username(session[:username])
       @name=s.name.titlecase
      if(params[:list]=="name")
        @addressbooks = Addressbook.find_by_sql("Select * from addressbooks order by name")
      elsif(params[:list]=="designation")
        @addressbooks = Addressbook.find_by_sql("Select * from addressbooks order by designation")
      elsif(params[:list]=="username")
        @addressbooks = Addressbook.find_by_sql("Select * from addressbooks order by username")
      elsif(params[:list]=="role")
        @addressbooks = Addressbook.find_by_sql("Select * from addressbooks order by role")
      elsif(params[:list]=="email")
        @addressbooks = Addressbook.find_by_sql("Select * from addressbooks order by email")
      else
        @addressbooks = Addressbook.find_by_sql("Select * from addressbooks")
      end
    else redirect_to "/addressbooks/login" and return
    end
  end

  def login
  end

  def homeuser
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
    @addressbook=Addressbook.new
    @addressbook=Addressbook.find_by_sql("Select * from addressbooks where username='#{session[:username]}'")
  end
  def passwordrecovery

  end

  def passwordsent
    if(params[:email]!="")
      u=Addressbook.find_by_email(params[:email])
       if(!u)
          redirect_to "/addressbooks/passwordrecovery",:notice=>"E-mail doesn't exist" and return
       else
            if u and u.send_new_password
             flash[:message]  = "A new password has been sent by email."
            else
               flash[:warning]  = "Couldn't send password"
            end
       end
    elsif(params[:username]!="")
      u=Addressbook.new
      u=Addressbook.find_by_username(params[:username])
       if(!u)
        redirect_to "/addressbooks/passwordrecovery",:notice=>"Username doesn't exist" and return
       else
         if u and u.send_new_password
          flash[:message]  = "A new password has been sent by email."
         else
          flash[:warning]  = "Couldn't send password"
         end
       end
     else
      redirect_to "/addressbooks/passwordrecovery",:notice=>"Enter either username or email" and return
    end
 end
end
