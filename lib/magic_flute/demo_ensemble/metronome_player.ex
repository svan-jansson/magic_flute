defmodule MagicFlute.DemoEnsemble.MetronomePlayer do
  @moduledoc false

  use MagicFlute.Player, instrument: {:percussive, 3}

  def read_notes(bar, 1) do
    IO.inspect("bar #{bar}: whole")
    [~n(d3 5 ff)]
  end

  def read_notes(bar, beat) when beat == 5 or beat == 9 or beat == 13 do
    IO.inspect("bar #{bar}: quarter")
    [~n(c3 5 mp)]
  end

  def read_notes(bar, beat) when rem(beat, 2) != 0 do
    IO.inspect("bar #{bar}: eight")
    [~n(c3 5 pp)]
  end
end
