class CreateAthletes < ActiveRecord::Migration
  def change
    create_table :athletes do |t|
      t.integer :facebook_id
      t.string :name

      t.timestamps
    end
  end
end
