class AddCityStateToCompanies < ActiveRecord::Migration[6.0]
  def up
    add_column :companies, :city, :string, :limit => 100
    add_column :companies, :state, :string, :limit => 100
  end

  def down
    remove_column :companies, :city
    remove_column :companies, :state
  end
end
