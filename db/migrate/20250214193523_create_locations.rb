class CreateLocations < ActiveRecord::Migration[8.0]
  def change
    create_table :locations do |t|
      t.string :street, null: false
      t.string :city, null: false
      t.string :state, null: false
      t.integer :number
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
