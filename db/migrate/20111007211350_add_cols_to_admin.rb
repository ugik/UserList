class AddColsToAdmin < ActiveRecord::Migration
  def change
    add_column :admin, :company_name, :string
    add_column :admin, :league_id, :integer
  end
end
