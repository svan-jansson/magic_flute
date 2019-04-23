defmodule MagicFlute.DemoEnsemble.PianoPlayer do
  use MagicFlute.Player, instrument: {:piano, 1}

  def play(bar, 13) when rem(bar, 2) > 0 do
    play_chord([60, 63, 65, 67], 100, :mp)
  end
end
