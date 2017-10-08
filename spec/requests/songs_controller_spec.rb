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

    context 'when the title is nil' do
      let(:params) do
        {
          title: nil,
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

      it 'returns a 400' do
        post '/songs', params: params, headers: headers
        expect(response).to_not be_successful
        expect(JSON.parse(response.body)['error']).to eq 'Could not create song'
      end
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

  describe 'cleanup_text' do
    it 'returns a cleaned version of the text' do
      params = {song_text: "\nC Em\n\nC                       Em\nGround control to Major Tom\nC                       Em\nGround control to Major Tom\nAm        Am7               D7\nTake your protein pills and put your helmet on\n\nC                       Em\nGround control to Major Tom\nC                             Em\nCommencing countdown, engines on\nAm    Am7              D7\nCheck ignition and may Gods love be with you\n\nC                               E7\nThis is ground control to Major Tom\n                       F\nYou’ve really made the grade\n        Fm             C                     F\nAnd the papers want to know whose shirts you wear\n        Fm                C              F\nNow its time to leave the capsule if you dare\n\nC                              E7\nThis is Major Tom to ground control\n                         F\nI’m stepping through the door\n        Fm            C             F\nAnd I’m floating in a most peculiar way\n        Fm              C           F\nAnd the stars look very different today\n\n    Fmaj7\nFor here\n     Em   \nAm I sitting in a tin can\nFmaj7         Em\nFar above the world\nBb              Am\nPlanet earth is blue\n            G             F\nAnd there’s nothing I can do\n\nC  F  G  A  A    2x\n\nFmaj7  Em  A  C  D  E\n\nC                                    E7\nThough I’m past one hundred thousand miles\n                 F\nI’m feeling very still\n      Fm                 C                  F\nAnd I think my spaceship knows which way to go\n        Fm              C             F\nTell me wife I love her very much she knows\n\nG                 E7\nGround control to Major Tom\n     Am                     Am7\nYour circuits dead, there’s something wrong\n        D7\nCan you hear me, Major Tom? \n        C\nCan you hear me, Major Tom? \n        D7\nCan you hear me, Major Tom? \n\nCan you....\n\n    Fmaj7\nFor here\n     Em   \nAm I sitting in a tin can\nFmaj7         Em\nFar above the world\nBb              Am\nPlanet earth is blue\n            G             F\nAnd there’s nothing I can do\n\nC F G A\n\nFmaj7  Em  A  C  D    E\n\n"}
      expected_output = {'cleaned_text' => "C Em\n\nC                       Em\nGround control to Major Tom\nC                       Em\nGround control to Major Tom\nAm        Am7               D7\nTake your protein pills and put your helmet on\n\n\nC                       Em\nGround control to Major Tom\nC                             Em\nCommencing countdown, engines on\nAm    Am7              D7\nCheck ignition and may Gods love be with you\n\n\nC                               E7\nThis is ground control to Major Tom\n                       F\nYou’ve really made the grade\n        Fm             C                     F\nAnd the papers want to know whose shirts you wear\n        Fm                C              F\nNow its time to leave the capsule if you dare\n\n\nC                              E7\nThis is Major Tom to ground control\n                         F\nI’m stepping through the door\n        Fm            C             F\nAnd I’m floating in a most peculiar way\n        Fm              C           F\nAnd the stars look very different today\n\n\n    Fmaj7\nFor here\n     Em   \nAm I sitting in a tin can\nFmaj7         Em\nFar above the world\nBb              Am\nPlanet earth is blue\n            G             F\nAnd there’s nothing I can do\n\n\nC  F  G  A  A    2x\n\nFmaj7  Em  A  C  D  E\n\nC                                    E7\nThough I’m past one hundred thousand miles\n                 F\nI’m feeling very still\n      Fm                 C                  F\nAnd I think my spaceship knows which way to go\n        Fm              C             F\nTell me wife I love her very much she knows\n\n\nG                 E7\nGround control to Major Tom\n     Am                     Am7\nYour circuits dead, there’s something wrong\n        D7\nCan you hear me, Major Tom? \n        C\nCan you hear me, Major Tom? \n        D7\nCan you hear me, Major Tom? \n\nCan you....\n\n\n    Fmaj7\nFor here\n     Em   \nAm I sitting in a tin can\nFmaj7         Em\nFar above the world\nBb              Am\nPlanet earth is blue\n            G             F\nAnd there’s nothing I can do\n\n\nC F G A\n\nFmaj7  Em  A  C  D    E\n\n"}
      post '/songs/cleanup_text', params: params, headers: headers
      expect(response).to be_successful
      expect(JSON.parse(response.body)).to eq expected_output
    end
  end
end