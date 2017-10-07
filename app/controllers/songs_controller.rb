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
end
