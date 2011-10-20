class TeamUserAssociation < ActiveRecord::Base
  self.abstract_class = true
  establish_connection :remote_console
  
  belongs_to :team
  belongs_to :user

end
