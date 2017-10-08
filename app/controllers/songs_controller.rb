class SongsController < ApplicationController
  def create
    song = Song.create(name: params[:title])

    line_index = 1
    lines = {}

    params[:lyrics].each do |line|
      lines[line_index] = Line.create!(words: line, index: line_index, song: song).id
      line_index += 1
    end

    params[:chords].each do |chord_hash|
      ChordPlacement.create!(chord: chord_hash[:chord], line_id: lines[chord_hash[:line]], position: chord_hash[:position])
    end

    render json: {success: true, id: song.id}
  end

  def show
    song = Song.find(params[:id])

    render json: {
      id: song.id,
      title: song.name,
      lyrics: song.lines.map(&:words),
      chords: song.lines.map(&:chord_placements).flatten.map(&:to_json)
    }
  end
end
