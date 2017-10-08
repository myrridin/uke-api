class SongsController < ApplicationController
  def create
    begin
      song = Song.create(name: params[:title])

      unless song.id
        render json: {success: false, error: 'Could not create song'}, status: :bad_request
        return
      end

      line_index = 1
      lines = {}

      params[:lyrics].each do |line|
        line = Line.create!(words: line, index: line_index, song: song)

        unless line.id
          render json: {success: false, error: "Could not create line #{line_index}"}, status: :bad_request
          return
        end

        lines[line_index] = line.id
        line_index += 1
      end

      params[:chords].each do |chord_hash|
        chord_placement = ChordPlacement.create(chord: chord_hash[:chord], line_id: lines[chord_hash[:line]], position: chord_hash[:position])

        unless chord_placement.id
          render json: {success: false, error: "Could not create chord with params #{chord_hash}"}, status: :bad_request
          return
        end
      end
    rescue StandardError
      render json: {success: false, error: "There was an error creating this song."}, status: :bad_request
      return
    end

    render json: {success: true, id: song.id}
  end

  def show
    song = Song.where(id: params[:id]).first

    unless song
      render json: {success: false, error: "Song with id #{params[:id]} could not be found."}, status: :not_found
      return
    end

    render json: {
      id: song.id,
      title: song.name,
      lyrics: song.lines.map(&:words),
      chords: song.lines.map(&:chord_placements).flatten.map(&:to_json)
    }
  end
end
