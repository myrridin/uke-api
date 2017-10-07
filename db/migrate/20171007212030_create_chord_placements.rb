class CreateChordPlacements < ActiveRecord::Migration[5.1]
  def change
    create_table :chord_placements do |t|
      t.references :line, foreign_key: true
      t.integer :position
      t.string :chord

      t.timestamps
    end
  end
end
