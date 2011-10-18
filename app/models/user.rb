class User < ActiveRecord::Base
  self.abstract_class = true
  establish_connection :remote_console

  has_many :team_user_associations
  has_many :teams, :through => :team_user_associations
  has_many :scores
  
end
