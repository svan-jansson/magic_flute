defmodule MagicFlute.DemoEnsemble.BassPlayer do
  @moduledoc false

  use MagicFlute.Player, instrument: {:bass, 1}

  def read_notes(bar, beat) when rem(bar, 2) == 0 and rem(beat, 4) == 0 do
    [
      ~n(g1 100 mf)
    ]
  end

  def read_notes(_bar, beat) when rem(beat, 4) == 0 do
    [
      ~n(c1 100 ff)
    ]
  end

  def read_notes(bar, 13) when rem(bar, 2) > 0 do
    [
      ~n(ab1 100 f)
    ]
  end
end
