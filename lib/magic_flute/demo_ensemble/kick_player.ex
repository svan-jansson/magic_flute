defmodule MagicFlute.DemoEnsemble.KickPlayer do
  use MagicFlute.Player, instrument: {:percussive, 5}

  def read_notes(_bar, beat) when beat == 1 do
    [
      ~n(c-1 10 mf)
    ]
  end
end
