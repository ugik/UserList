class Challenge < ActiveRecord::Base
  extend ActiveSupport::Memoizable
  
  self.abstract_class = true
  establish_connection(
    :adapter => "mysql2"
    :username => "gynxpFLh7"
    :password => "MLPTFchgCvBmvWEx"
    :host => "production-ro.ct1vjcyxovqq.us-east-1.rds.amazonaws.com"
    :database => "FRONTEND"
    :encoding => "utf8"
    :reconnect => "false"
    :pool => "5"
  )
  
  has_many :teams, :foreign_key => "league_id"
  has_one :division, :foreign_key => "league_id"

  attr_accessible :name, :league_id, :activation_date, :task_selection_date, :eligible_members, :splash_description
  
  def num_teams
    self.teams.size
  end
  memoize :num_teams

  def num_users_on_teams
    @users_on_teams = 0
    self.teams.each { |t| @users_on_teams += t.users.size }
    @users_on_teams
  end
  memoize :num_users_on_teams

  def top_teams
    @top_teams = {}
    @top_teams = Score.in_challenge(self.id).teams_in_all_divisions.limit(5).
                         order("sum_points DESC, MAX(#{Score.table_name}.
                         earned_at) DESC").sum(:points)    
    return @top_teams
  end
  memoize :top_teams

  def rank_top_teams    # old (slow) way of getting top teams
    @users_on_teams = 0
    @team_points = {}    # hash of team names, points
    self.teams.each { |t| 
        @team_points[t.name] = 0
        @users_on_teams += t.users.size
        t.users.each { |i| 
            @team_points[t.name] += i.scores.map(&:points).sum } }
    @top_teams = []      # array of top team scores
    @top_teams = @team_points.sort_by {|key, value| value}.reverse!
    return @users_on_teams, @top_teams
  end

end
