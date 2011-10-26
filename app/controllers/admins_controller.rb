class AdminsController < ApplicationController
  
  
  def index
    @admins = Admin.all(:order => "league_id")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @admins }
    end
  end

  def show
    @admin = Admin.find(params[:id])
    @challenges = @admin.challenges

    if session[:cached_id] != @admin.id           # if looking at un-cached challenge
      expire_fragment('challenges_cache')   # expire cache
      session[:cached_id] = @admin.id             # reset cookie
      logger.debug("\n>>> Cached ID:"+ session[:cached_id].to_s)
    end

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

end
