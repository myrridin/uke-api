require 'rails_helper'

RSpec.describe SongsController, type: :request do
  describe '#create' do
    let(:params) do
      {
        title: "My Awesome Song",
        lyrics: [
          "When I look up",
          "And see the sun",
          "It is",
          "Awesome"
        ],
        chords: [
          {
            chord: "Am",
            line: 1,
            position: 3
          },
          {
            chord: "F",
            line: 1,
            position: 10
          }
        ]
      }.to_json.to_s
    end

    let(:headers) { {"CONTENT_TYPE" => "application/json"} }

    it 'creates the song with the given title' do
      post '/songs/create', params: params, headers: headers
      expect(response).to be_successful
      expect(Song.count).to eq 1
      expect(Song.last.name).to eq 'My Awesome Song'
    end

    it 'creates the associated lines in the right order' do
      post '/songs/create', params: params, headers: headers
      expect(response).to be_successful

      expect(Line.order(:index).map(&:words)).to eq [
        "When I look up",
        "And see the sun",
        "It is",
        "Awesome"
      ]
    end

    it 'creates chord placements with the right line association' do
      post '/songs/create', params: params, headers: headers
      expect(response).to be_successful

      expect(ChordPlacement.count).to eq 2
      expect(ChordPlacement.all.map(&:line_id)).to match_array [Song.last.lines.first.id, Song.last.lines.first.id]
    end
  end
end