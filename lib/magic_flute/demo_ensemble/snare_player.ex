defmodule MagicFlute.DemoEnsemble.SnarePlayer do
  use MagicFlute.Player, instrument: {:percussive, 6}

  def read_notes(_bar, beat) when beat == 9 do
    [{60, 10, :mf}]
  end
end
