defmodule MagicFlute.DemoEnsemble.SnarePlayer do
  @moduledoc false

  use MagicFlute.Player, instrument: {:percussive, 6}

  def read_notes(_bar, beat) when beat == 9 do
    [
      ~n(c3 10 mf)
    ]
  end
end
