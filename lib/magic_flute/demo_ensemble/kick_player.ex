defmodule MagicFlute.DemoEnsemble.KickPlayer do
  use MagicFlute.Player, instrument: {:percussive, 5}

  def play(_bar, beat) when beat == 1 do
    play_note(24, 10, :mf)
  end
end
