defmodule MagicFlute.DemoEnsemble.HiHatPlayer do
  @moduledoc false

  use MagicFlute.Player, instrument: {:percussive, 3}

  def read_notes(_bar, beat) when rem(beat, 4) == 0 do
    [
      ~n(g3 10 mf)
    ]
  end
end
