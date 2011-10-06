class ChallengesController < ApplicationController

  def index
    @challenges = Challenge.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @challenges }
    end
  end

  def show
    @challenge = Challenge.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @challenges }
    end
  end

end
