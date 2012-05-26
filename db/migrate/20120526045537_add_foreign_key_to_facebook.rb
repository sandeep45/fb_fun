class AddForeignKeyToFacebook < ActiveRecord::Migration
  def change
    add_column :facebooks, :user_id, :integer
  end
end
