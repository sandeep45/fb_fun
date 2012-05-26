class AddAccessDataToFacebook < ActiveRecord::Migration
  def change
    add_column :facebooks, :access_token, :string
    add_column :facebooks, :expires_at, :datetime
  end
end
