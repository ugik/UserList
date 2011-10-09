class User < ActiveRecord::Base

  has_many :challenges, :foreign_key => "league_id"

  attr_accessible :name, :email, :company_name, :league_id
  
end
