class AddFacebookStuffToFacebook < ActiveRecord::Migration
  def change
    add_column :facebooks, :uid, :string
    add_column :facebooks, :name, :string
    add_column :facebooks, :username, :string
    add_column :facebooks, :hometown, :string
    add_column :facebooks, :gender, :string
    add_column :facebooks, :email, :string
    add_column :facebooks, :verified, :boolean
    add_column :facebooks, :up_time, :datetime
    add_column :facebooks, :link, :string
    add_column :facebooks, :timezone, :integer
  end
end
