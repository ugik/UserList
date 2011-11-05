class AdminsController < ApplicationController
  
  
  def index
    @admins = Admin.all(:order => "league_id")

    logger.debug("\n I'm HERE!!!")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @admins }
    end
  end

  def show
    if session[:shown_id] == nil
      session[:shown_id] = []                     # init array of shown id's
    end
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
    session[:shown_id] = []                       # init array of shown id crumbs
    @admin = Admin.find(params[:id])
    @title = "Edit admin #{@admin.name}"
  end

  def update
    @admin = Admin.find(params[:id])
    if @admin.update_attributes(params[:admin])
#      redirect_to @admin
      redirect_to :action => 'index'
    else
      @title = "Edit admin"
      render 'edit'
    end
  end

  def update_admins
    logger.debug("\n>>> Updating Admins")

    @users = User.all(:conditions => ['admin'])   # all admin users
    logger.debug(">>> " + @users.size.to_s + "Admins")
    @users.each do |user|
      division_id = user.division_id
      league_id = Division.find_by_id(division_id).league_id
      company_name = League.find_by_id(league_id).name

      admin = Admin.find_by_email(user.email)
      if admin == nil
        logger.debug(">>> ...Adding Admin")
        Admin.create(:name => user.first_name + " " + user.last_name, 
                   :email => user.email,
                   :encrypted_password => user.encrypted_password,
                   :salt => user.password_salt,
                   :league_id => league_id,
                   :company_name => company_name )
      else
        logger.debug(">>> ...Updating Admin" + admin.name)
        admin.name = user.first_name + " " + user.last_name
        admin.email = user.email
        admin.encrypted_password = user.encrypted_password
        admin.salt = user.password_salt
        admin.league_id = league_id
        admin.company_name = company_name
        admin.save
      end
    end
    
    redirect_to :action => 'updated_admins'
  end
  
  def handle_cache
    if session[:cached_id] != @admin.id           # if looking at un-cached challenge
      expire_fragment('challenges_cache')         # expire cache
      session[:cached_id] = @admin.id             # reset cookie
      session[:shown_id] << @admin.id             # add to crumbs
      logger.debug("\n>>> Cached ID:"+ session[:cached_id].to_s + " ...trail:" + session[:shown_id].join(","))
    end

  end
  
end
