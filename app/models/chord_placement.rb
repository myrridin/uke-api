class ChordPlacement < ApplicationRecord
  belongs_to :line

  def to_json
    {
      chord: chord,
      line: line.index,
      position: position
    }
  end
end
