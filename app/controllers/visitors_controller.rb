class VisitorsController < ApplicationController
  # GET /visitors
  # GET /visitors.xml
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
     @visitors=Visitor.new
     if(params[:list]=="name")
     @visitors = Visitor.find_by_sql("Select * from visitors where username='#{session[:username]}' order by name")
    elsif(params[:list]=="company")
      @visitors = Visitor.find_by_sql("Select * from visitors where username='#{session[:username]}' order by company")
    elsif(params[:list]=="dateofvisit")
      @visitors = Visitor.find_by_sql("Select * from visitors where username='#{session[:username]}' order by dateofvisit")
    else
    @visitors = Visitor.find_by_sql("Select * from visitors where username='#{session[:username]}'")
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @visitors }
    end
  end

  # GET /visitors/1
  # GET /visitors/1.xml
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
    @visitor = Visitor.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @visitor }
    end
  end

  # GET /visitors/new
  # GET /visitors/new.xml
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
    @visitor = Visitor.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @visitor }
    end
  end

  # GET /visitors/1/edit
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
    @visitor = Visitor.find(params[:id])
  end

  # POST /visitors
  # POST /visitors.xml
  def create
    @visitor = Visitor.new(params[:visitor])
    addressbook=Addressbook.new
    addressbook=Addressbook.find_by_sql("select name from addressbooks where username='#{session[:username]}'")
    @visitor.officer=addressbook[0].name
    @visitor.username=session[:username]
     @visitor.created_at=Time.now+5.hours+30.minutes
     @visitor.updated_at=Time.now+5.hours+30.minutes
        
    respond_to do |format|
      if @visitor.save
        
        format.html { redirect_to(@visitor, :notice => 'Visitor was successfully created.') }
        format.xml  { render :xml => @visitor, :status => :created, :location => @visitor }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @visitor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /visitors/1
  # PUT /visitors/1.xml
  def update
    @visitor = Visitor.find(params[:id])
    @visitor.updated_at=Time.now+5.hours+30.minutes
    respond_to do |format|
      if @visitor.update_attributes(params[:visitor])
        format.html { redirect_to(@visitor, :notice => 'Visitor was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @visitor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /visitors/1
  # DELETE /visitors/1.xml
  def destroy
     if(!session[:username] or session[:role]=='administrator')
      redirect_to "/addressbooks/login" and return
     end
      if(Time.now-1.hours>session[:time].to_time)
        redirect_to "/addressbooks/logout",:notice=>"Session expired" and return
      else
        session[:time]=Time.now
      end
    @visitor = Visitor.find(params[:id])
    @visitor.destroy

    respond_to do |format|
      format.html { redirect_to "/visitors" }
      format.xml  { head :ok }
    end
  end
end
