defmodule MagicFlute.DemoEnsemble.MetronomePlayer do
  use MagicFlute.Player, instrument: {:percussive, 3}

  def play(bar, 1) do
    IO.inspect("bar #{bar}: whole")
    play_note(62, 5, :ff)
  end

  def play(bar, beat) when beat == 5 or beat == 9 or beat == 13 do
    IO.inspect("bar #{bar}: quarter")
    play_note(60, 5, :mp)
  end

  def play(bar, beat) when rem(beat, 2) != 0 do
    IO.inspect("bar #{bar}: eight")
    play_note(60, 5, :mp)
  end
end
