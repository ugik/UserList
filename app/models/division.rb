class Division < ActiveRecord::Base
  self.abstract_class = true
  establish_connection :remote_console
  
  has_many :teams, :foreign_key => "league_id"
  has_many :users
  
end
