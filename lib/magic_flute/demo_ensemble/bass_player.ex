defmodule MagicFlute.DemoEnsemble.BassPlayer do
  use MagicFlute.Player, instrument: {:bass, 1}

  def read_notes(bar, beat) when rem(bar, 2) == 0 and rem(beat, 4) == 0 do
    [
      {36, 100, :mf}
    ]
  end

  def read_notes(_bar, beat) when rem(beat, 4) == 0 do
    [
      {41, 100, :ff}
    ]
  end

  def read_notes(bar, 13) when rem(bar, 2) > 0 do
    [
      {32, 100, :f}
    ]
  end
end
