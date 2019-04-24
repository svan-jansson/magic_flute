defmodule MagicFlute.DemoEnsemble.MetronomePlayer do
  use MagicFlute.Player, instrument: {:percussive, 3}

  def read_notes(bar, 1) do
    IO.inspect("bar #{bar}: whole")
    [{62, 5, :ff}]
  end

  def read_notes(bar, beat) when beat == 5 or beat == 9 or beat == 13 do
    IO.inspect("bar #{bar}: quarter")
    [{60, 5, :mp}]
  end

  def read_notes(bar, beat) when rem(beat, 2) != 0 do
    IO.inspect("bar #{bar}: eight")
    [{60, 5, :mp}]
  end
end
