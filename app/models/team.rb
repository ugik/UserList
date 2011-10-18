class Team < ActiveRecord::Base
  self.abstract_class = true
  establish_connection :remote_console

  has_many :team_user_associations
  has_many :users, :through => :team_user_associations

end
