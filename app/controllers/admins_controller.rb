class AdminsController < ApplicationController
  
  
  def index
    @admins = Admin.all(:order => "league_id")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @admins }
    end
  end

  def show
    if session[:shown_last] == nil
      session[:shown_last] = 0
    end
    if session[:shown_last] > session[:shown_id].size
      session[:shown_last] = 0
    end

    if params[:id] == "0"
      if session[:shown_last] == session[:shown_id].size    # cycle back
        session[:shown_last] = 0
      end

      crumbs = Array.new(session[:shown_id])
      session[:kiosk_mode] = true
      logger.debug(">>> in Admin Controller CRUMB ITEM " + session[:shown_last].to_s)
      logger.debug(">>> in Admin Controller CRUMBS " + crumbs.join(","))
      logger.debug(">>> in Admin Controller SHOW " + crumbs[session[:shown_last]].to_s)

      @admin = Admin.find(session[:shown_id][session[:shown_last]])    # show next id from crumbs
      session[:shown_last] += 1
      expire_fragment('challenges_cache')         # expire cache
    else
      session[:kiosk_mode] = false
      @admin = Admin.find(params[:id])
      handle_cache

    end
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
    session[:shown_id] = []                       # init array of shown id crumbs

    @admin = Admin.find(params[:id])
    if @admin.update_attributes(params[:admin])
#      redirect_to @admin
      redirect_to :action => 'index'
    else
      @title = "Edit admin"
      render 'edit'
    end
  end

  def handle_cache
    if session[:shown_id] == nil
      session[:shown_id] = []                     # init array of shown id's
    end
    if session[:cached_id] != @admin.id           # if looking at un-cached challenge
      expire_fragment('challenges_cache')         # expire cache
      session[:cached_id] = @admin.id             # reset cookie
      session[:shown_id] << @admin.id             # add to crumbs
      logger.debug("\n>>> Cached ID:"+ session[:cached_id].to_s + " ...trail:" + session[:shown_id].join(","))
    end

  end
end
