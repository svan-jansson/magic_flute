defmodule MagicFlute.DemoEnsemble.KickPlayer do
  use MagicFlute.Player, instrument: {:percussive, 5}

  def read_notes(_bar, beat) when beat == 1 do
    [{24, 10, :mf}]
  end
end
