class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
    	t.integer :user_id
      t.string :email
      
      t.timestamps
    end
  end
end
