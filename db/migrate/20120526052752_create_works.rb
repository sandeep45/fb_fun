class CreateWorks < ActiveRecord::Migration
  def change
    create_table :works do |t|
      t.integer :facebook_id
      t.string :name
      t.string :location
      t.string :position
      t.text :description

      t.timestamps
    end
  end
end
