defmodule MagicFlute.DemoEnsemble.PianoPlayer do
  use MagicFlute.Player, instrument: {:piano, 1}

  def read_notes(bar, 13) when rem(bar, 2) > 0 do
    [
      ~n(c3 100 mp),
      ~n(d#3 100 mp),
      ~n(f3 100 mp),
      ~n(g#3 100 mp)
    ]
  end
end
