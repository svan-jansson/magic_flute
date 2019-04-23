defmodule MagicFlute.Ensemble.SnarePlayer do
  use MagicFlute.Player, instrument: {:percussive, 6}

  def play(_bar, beat) when beat == 9 do
    play_note(60, 10, :mf)
  end
end
