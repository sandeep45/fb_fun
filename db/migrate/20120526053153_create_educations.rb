class CreateEducations < ActiveRecord::Migration
  def change
    create_table :educations do |t|
      t.integer :facebook_id
      t.string :name
      t.string :type
      t.integer :year
      t.string :degree

      t.timestamps
    end
  end
end
