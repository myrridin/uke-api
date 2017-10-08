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
      post '/songs', params: params, headers: headers
      expect(response).to be_successful
      expect(Song.count).to eq 1
      expect(Song.last.name).to eq 'My Awesome Song'
    end

    it 'creates the associated lines in the right order' do
      post '/songs', params: params, headers: headers
      expect(response).to be_successful

      expect(Line.order(:index).map(&:words)).to eq [
        "When I look up",
        "And see the sun",
        "It is",
        "Awesome"
      ]
    end

    it 'creates chord placements with the right line association' do
      post '/songs', params: params, headers: headers
      expect(response).to be_successful

      expect(ChordPlacement.count).to eq 2
      expect(ChordPlacement.all.map(&:line_id)).to match_array [Song.last.lines.first.id, Song.last.lines.first.id]
    end
  end

  describe '#show' do
    let(:song) { Song.create(name: "Mary Jane's Last Dance") }
    before(:each) do
      line = Line.create(song: song, words: "She grew up in an Indiana town", index: 1)
      line2 = Line.create(song: song, words: "Had a good lookin Mama who never was around", index: 2)
      ChordPlacement.create(line: line, chord: 'Am', position: 0)
      ChordPlacement.create(line: line, chord: 'G', position: 18)
      ChordPlacement.create(line: line2, chord: 'D', position: 0)
      ChordPlacement.create(line: line2, chord: 'Am', position: 27)
    end

    it 'returns a json representation of the song' do
      expected_hash = {
        id: song.id,
        title: "Mary Jane's Last Dance",
        lyrics: [
          "She grew up in an Indiana town",
          "Had a good lookin Mama who never was around"
        ],
        chords: [
          {
            chord: "Am",
            line: 1,
            position: 0
          },
          {
            chord: "G",
            line: 1,
            position: 18
          },
          {
            chord: "D",
            line: 2,
            position: 0
          },
          {
            chord: "Am",
            line: 2,
            position: 27
          }
        ]
      }

      get "/songs/#{song.id}"
      expect(response).to be_successful
      json = response.body
      expect(json).to eq(expected_hash.to_json)
    end
  end
end