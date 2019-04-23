defmodule MagicFlute.Ensemble.HiHatPlayer do
  use MagicFlute.Player, instrument: {:percussive, 3}

  def play(_bar, beat) when rem(beat, 4) == 0 do
    play_note(60, 10, :mf)
  end
end
