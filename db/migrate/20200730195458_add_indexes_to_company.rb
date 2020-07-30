class AddIndexesToCompany < ActiveRecord::Migration[6.0]
  def change
    add_index :companies, ['id'], name:'index_companies_on_id'
    add_index :companies, ['zip_code'], name:'index_companies_on_zip_code'
  end
end
