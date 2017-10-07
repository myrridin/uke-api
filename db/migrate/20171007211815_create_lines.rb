class CreateLines < ActiveRecord::Migration[5.1]
  def change
    create_table :lines do |t|
      t.references :song, foreign_key: true
      t.string :words
      t.integer :index

      t.timestamps
    end
  end
end
