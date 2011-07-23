class TasktypesController < ApplicationController
  # GET /tasktypes
  # GET /tasktypes.xml
  def index
    redirect_to "/404.html" and return
    @tasktypes = Tasktype.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tasktypes }
    end
  end

  # GET /tasktypes/1
  # GET /tasktypes/1.xml
  def show
       redirect_to "/404.html" and return 
   @tasktype = Tasktype.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tasktype }
    end
  end

  # GET /tasktypes/new
  # GET /tasktypes/new.xml
  def new
    redirect_to "/404.html" and return
    @tasktype = Tasktype.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tasktype }
    end
  end

  # GET /tasktypes/1/edit
  def edit
    redirect_to "/404.html" and return
    @tasktype = Tasktype.find(params[:id])
  end

  # POST /tasktypes
  # POST /tasktypes.xml
  def create
    @tasktype = Tasktype.new(params[:tasktype])

    respond_to do |format|
      if @tasktype.save
        format.html { redirect_to(@tasktype, :notice => 'Tasktype was successfully created.') }
        format.xml  { render :xml => @tasktype, :status => :created, :location => @tasktype }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tasktype.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tasktypes/1
  # PUT /tasktypes/1.xml
  def update
    @tasktype = Tasktype.find(params[:id])

    respond_to do |format|
      if @tasktype.update_attributes(params[:tasktype])
        format.html { redirect_to(@tasktype, :notice => 'Tasktype was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tasktype.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tasktypes/1
  # DELETE /tasktypes/1.xml
  def destroy
    redirect_to "/404.html" and return
    @tasktype = Tasktype.find(params[:id])
    @tasktype.destroy

    respond_to do |format|
      format.html { redirect_to(tasktypes_url) }
      format.xml  { head :ok }
    end
  end
end
