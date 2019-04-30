defmodule MagicFlute.DemoEnsemble.SnarePlayer do
  @moduledoc false

  use MagicFlute.Player, instrument: {:percussive, 6}

  def read_notes(_bar, beat) when rem(beat, 4) == 0 do
    [
      ~n(c3 10 mp)
    ]
  end

  def read_notes(_bar, beat) when rem(beat, 4) == 1 do
    [
      ~n(f3 10 p)
    ]
  end

  def read_notes(_bar, beat) when rem(beat, 4) == 2 do
    [
      ~n(a3 10 p)
    ]
  end

  def read_notes(_bar, beat) when rem(beat, 4) == 3 do
    [
      ~n(a5 10 mf)
    ]
  end

  def read_notes(_bar, beat) when rem(beat, 4) == 4 do
    [
      ~n(b3 10 p)
    ]
  end
end
