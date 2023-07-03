class AddCreatedByIntoUsersAndParcels < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :created_by, :int
    add_column :parcels, :created_by, :int
    add_foreign_key :parcels, :users, column: :created_by
  end
end
