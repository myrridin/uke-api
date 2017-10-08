require 'rails_helper'

RSpec.describe Parser do
  describe '#cleanup' do
    let(:input_text) do
      <<-EOF

C Em

C                       Em
Ground control to Major Tom
C                       Em
Ground control to Major Tom
Am        Am7               D7
Take your protein pills and put your helmet on

C                       Em
Ground control to Major Tom
C                             Em
Commencing countdown, engines on
Am    Am7              D7
Check ignition and may Gods love be with you

C                               E7
This is ground control to Major Tom
                       F
You’ve really made the grade
        Fm             C                     F
And the papers want to know whose shirts you wear
        Fm                C              F
Now its time to leave the capsule if you dare

C                              E7
This is Major Tom to ground control
                         F
I’m stepping through the door
        Fm            C             F
And I’m floating in a most peculiar way
        Fm              C           F
And the stars look very different today

    Fmaj7
For here
     Em   
Am I sitting in a tin can
Fmaj7         Em
Far above the world
Bb              Am
Planet earth is blue
            G             F
And there’s nothing I can do

C  F  G  A  A    2x

Fmaj7  Em  A  C  D  E

C                                    E7
Though I’m past one hundred thousand miles
                 F
I’m feeling very still
      Fm                 C                  F
And I think my spaceship knows which way to go
        Fm              C             F
Tell me wife I love her very much she knows

G                 E7
Ground control to Major Tom
     Am                     Am7
Your circuits dead, there’s something wrong
        D7
Can you hear me, Major Tom? 
        C
Can you hear me, Major Tom? 
        D7
Can you hear me, Major Tom? 

Can you....

    Fmaj7
For here
     Em   
Am I sitting in a tin can
Fmaj7         Em
Far above the world
Bb              Am
Planet earth is blue
            G             F
And there’s nothing I can do

C F G A

Fmaj7  Em  A  C  D    E

      EOF
    end

    let(:expected_output) do
      <<-EOF
C Em

C                       Em
Ground control to Major Tom
C                       Em
Ground control to Major Tom
Am        Am7               D7
Take your protein pills and put your helmet on


C                       Em
Ground control to Major Tom
C                             Em
Commencing countdown, engines on
Am    Am7              D7
Check ignition and may Gods love be with you


C                               E7
This is ground control to Major Tom
                       F
You’ve really made the grade
        Fm             C                     F
And the papers want to know whose shirts you wear
        Fm                C              F
Now its time to leave the capsule if you dare


C                              E7
This is Major Tom to ground control
                         F
I’m stepping through the door
        Fm            C             F
And I’m floating in a most peculiar way
        Fm              C           F
And the stars look very different today


    Fmaj7
For here
     Em   
Am I sitting in a tin can
Fmaj7         Em
Far above the world
Bb              Am
Planet earth is blue
            G             F
And there’s nothing I can do


C  F  G  A  A    2x

Fmaj7  Em  A  C  D  E

C                                    E7
Though I’m past one hundred thousand miles
                 F
I’m feeling very still
      Fm                 C                  F
And I think my spaceship knows which way to go
        Fm              C             F
Tell me wife I love her very much she knows


G                 E7
Ground control to Major Tom
     Am                     Am7
Your circuits dead, there’s something wrong
        D7
Can you hear me, Major Tom? 
        C
Can you hear me, Major Tom? 
        D7
Can you hear me, Major Tom? 

Can you....


    Fmaj7
For here
     Em   
Am I sitting in a tin can
Fmaj7         Em
Far above the world
Bb              Am
Planet earth is blue
            G             F
And there’s nothing I can do


C F G A

Fmaj7  Em  A  C  D    E

EOF
    end

    it 'cleans up the song text' do
      output = Parser.cleanup(input_text)
      expect(output).to eq expected_output
    end
  end
end