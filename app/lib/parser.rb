class Parser
  def self.cleanup(song_text)
    lines = song_text.gsub(/\n{3,}/, "\n\n").lines
    new_lines = []


    lines.each_with_index do |line, index|
      new_line = line.chomp

      if line.blank? && chord_line?(lines[index+1]) && index != 0 && !chord_line?(lines[index-1])
        new_lines << ''
        new_lines << ''
      else
        new_lines << new_line if valid_line?(new_line)
      end

    end

    output_text = new_lines.join("\n").strip
    output_text = output_text.gsub(/\n{4,}/, "\n\n\n") # 3 or more blank lines should be 2 blank lines
    # output_text = output_text.gsub(/[^\n]\n\n[^\n]/, "\n\n\n") # single blank lines should be 2 blank lines
    output_text += "\n\n" if output_text.lines.count.odd?
    output_text
  end

  def self.valid_line?(new_line)
    # Typically notes
    return false if new_line.strip[0] == '('

    # Markers for various song parts
    return false if new_line.strip[0..3] == 'Link'
    return false if new_line.strip[0..4] == 'Verse'
    return false if new_line.strip[0..5] == 'Chorus'
    return false if new_line.strip[0..5] == 'Bridge'

    true
  end

  def self.chord_line?(line)
    return false if line.nil?

    chord_regex = /((\\)?\b[A-G](?:(?:add|dim|aug|maj|mM|mMaj|sus|m|b|#|\d)?(?:\/[A-G0-9])?)*(?!\||—|-|\.|:)(?:\b|#)+)/
    line =~ chord_regex
  end
end