class AddCountryToLocation < ActiveRecord::Migration[8.0]
  def change
    add_column :locations, :country, :string, null: false
  end
end
