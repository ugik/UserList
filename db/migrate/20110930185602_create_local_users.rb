class CreateLocalUsers < ActiveRecord::Migration
  def change
    create_table :local_users do |t|
      t.string :name
      t.string :email

      t.timestamps
    end
  end
end
