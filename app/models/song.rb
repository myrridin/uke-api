class Song < ApplicationRecord
  has_many :lines

  validates_presence_of :name

  def to_text
    lines_with_chords = lines.map do |line|
      [
        line.chord_line,
        line.words
      ]
    end

    lines_with_chords.join("\n")
  end

  def lines
    Line.where(song_id: id).order(:index)
  end
end
