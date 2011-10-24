class Challenge < ActiveRecord::Base
  extend ActiveSupport::Memoizable
  
  self.abstract_class = true
  establish_connection(
    :adapter => "mysql2",
    :host => "production-ro.ct1vjcyxovqq.us-east-1.rds.amazonaws.com",
    :username => "gynxpFLh7",
    :password => "MLPTFchgCvBmvWEx",
    :database => "FRONTEND",
    :encoding => "utf8",
    :reconnect => "false",
    :pool => "5"
  )

  belongs_to :admin, :foreign_key => "league_id"
  has_many :challenge_memberships
  has_many :users, :through => :challenge_memberships
  has_many :teams, :primary_key => "league_id", :foreign_key => "league_id"

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

  def load_challenge_users_table(challenge_id, table)   # load registrations per day
    @challenge = Challenge.find(challenge_id)
    
    table.new_column('date', 'Date' )
    table.new_column('number', 'New') 
    table.new_column('number', 'Total')

    array = @challenge.users.count(:order => "DATE(users.created_at)", 
                   :group => "DATE(users.created_at)"
                   ).to_a
    
    i = 0
    extended_array = array.map{ |a| i+=a[1]; a+=[i]}    # add the running total to array

    logger.debug("Array First:"+ extended_array[0].to_s)

    table.add_rows(extended_array)
    @show_graph = true

    # Add Rows and Values 
#    table.add_rows([ 
#      [Date.parse('2011-08-15'), 1000], 
#      [Date.parse('2011-08-15'), 1170], 
#      [Date.parse('2011-08-18'), 1230]    ])

  end

end
