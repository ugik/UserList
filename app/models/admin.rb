class Admin < ActiveRecord::Base
  extend ActiveSupport::Memoizable

  has_many :leagues, :primary_key => "league_id"
  has_many :challenges, :primary_key => "league_id", :foreign_key => "league_id"
  has_many :divisions, :primary_key => "league_id", :foreign_key => "league_id"
  has_many :teams, :primary_key => "league_id", :foreign_key => "league_id"
  has_many :posts, :as => :postable, :order => "updated_at DESC"

  attr_accessible :name, :email, :company_name, :league_id

  def num_users_registered
    @users_registered = 0
    self.divisions.each { |t| @users_registered += t.users.count }
    @users_registered
  end  
  memoize :num_users_registered

end
