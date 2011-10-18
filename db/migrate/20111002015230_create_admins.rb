class CreateAdmins < ActiveRecord::Migration
  def self.up
    create_table :admin do |t|
      t.string :name
      t.string :email

      t.timestamps
    end
  end

  def self.down
    drop_table :admin
  end
end