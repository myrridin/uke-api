class Line < ApplicationRecord
  belongs_to :song
  has_many :chord_placements

  def chord_line
    last_chord = chord_placements.order('position DESC').first
    line_length = last_chord.position + last_chord.chord.length
    text = ' ' * (line_length - 1)
    chord_placements.each do |cp|
      text[cp.position] = cp.chord
    end
    text
  end
end
