defmodule MagicFlute.DemoEnsemble.HiHatPlayer do
  use MagicFlute.Player, instrument: {:percussive, 3}

  def read_notes(_bar, beat) when rem(beat, 4) == 0 do
    [{60, 10, :mf}]
  end
end
