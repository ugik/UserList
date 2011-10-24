class AdminsController < ApplicationController
  
  
  def index
    @admins = Admin.all(:order => "league_id")
    
    expire_fragment('challenges_cache')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @admins }
    end
  end

  def show
    @admin = Admin.find(params[:id])
    @challenges = @admin.challenges
    @data_table = GoogleVisualr::DataTable.new
    @show_graph = false
    load_data_table(@data_table)

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

  def load_data_table(table)   # load registrations per day
    table.new_column('date', 'Date' )
    table.new_column('number', 'New') 
    table.new_column('number', 'Total') 

    if not @admin.challenges.empty?
      array = User.count(:order => "DATE(created_at)", 
                     :group => "DATE(created_at)", 
                     :conditions => ['division_id=?', @admin.challenges.first.division.id.to_s]
                     ).to_a
    
      i = 0
      extended_array = array.map{ |a| i+=a[1]; a+=[i]}
  
      logger.debug("Array First:"+ extended_array[0].to_s)
    
      table.add_rows(extended_array)
      @show_graph = true

    # Add Rows and Values 
#    table.add_rows([ 
#      [Date.parse('2011-08-15'), 1000], 
#      [Date.parse('2011-08-15'), 1170], 
#      [Date.parse('2011-08-15'), 660], 
#      [Date.parse('2011-08-18'), 1230]    ])

    else
       logger.debug(">>> No Challenges for this admin")
    end
    
  end

end
