defmodule MagicFlute.DemoEnsemble.KickPlayer do
  @moduledoc false

  use MagicFlute.Player, instrument: {:percussive, 5}

  def read_notes(bar, beat) when rem(beat, 4) == 0 or bar == 1 do
    [
      ~n(c-1 10 mf)
    ]
  end
end
