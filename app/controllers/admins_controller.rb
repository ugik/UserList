class AdminsController < ApplicationController
  
  
  def index
    @admins = Admin.find_by_sql("SELECT * FROM admins")
    @data_table = GoogleVisualr::DataTable.new
    load_data_table(@data_table)
    
    expire_fragment('challenges_cache')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @admins }
    end
  end

  def show
    @admin = Admin.find(params[:id])
    @challenges = @admin.challenges

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @admin }
    end
  end

  def edit
    @admin = Admin.find(params[:id])
    @title = "Edit admin #{@admin.name}"
  end

  def update
    @admin = Admin.find(params[:id])
    if @admin.update_attributes(params[:admin])
      redirect_to @admin
    else
      @title = "Edit admin"
      render 'edit'
    end
  end

  def load_data_table(table)
    # Add Column Headers 
    table.new_column('string', 'Year' )
    table.new_column('number', 'Sales') 
    table.new_column('number', 'Expenses') 

    # Add Rows and Values 
    table.add_rows([ 
      ['2004', 1000, 400], 
      ['2005', 1170, 460], 
      ['2006', 660, 1120], 
      ['2007', 1030, 540] 
    ])
  end

end
