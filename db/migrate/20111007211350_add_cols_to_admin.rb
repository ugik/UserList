class AddColsToAdmin < ActiveRecord::Migration
  def change
    add_column :admins, :company_name, :string
    add_column :admins, :league_id, :integer
  end
end
