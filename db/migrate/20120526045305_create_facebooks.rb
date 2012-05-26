class CreateFacebooks < ActiveRecord::Migration
  def change
    create_table :facebooks do |t|

      t.timestamps
    end
  end
end
