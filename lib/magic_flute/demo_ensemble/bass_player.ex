defmodule MagicFlute.DemoEnsemble.BassPlayer do
  use MagicFlute.Player, instrument: {:bass, 1}

  def play(bar, beat) when rem(bar, 2) == 0 and rem(beat, 4) == 0 do
    play_note(36, 100, :mf)
  end

  def play(_bar, beat) when rem(beat, 4) == 0 do
    play_note(41, 100, :f)
  end
end
