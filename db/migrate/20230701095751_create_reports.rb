class CreateReports < ActiveRecord::Migration[6.1]
  def change
    create_table :reports do |t|
      t.string :file_name
      t.string :file_path
      t.timestamps
    end
  end
end
