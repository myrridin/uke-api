class Song < ApplicationRecord
  has_many :lines

  def to_text
    lines_with_chords = lines.map do |line|
      [
        line.chord_line,
        line.words
      ]
    end

    lines_with_chords.join("\n")
  end
end
