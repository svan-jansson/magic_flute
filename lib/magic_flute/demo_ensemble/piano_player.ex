defmodule MagicFlute.DemoEnsemble.PianoPlayer do
  use MagicFlute.Player, instrument: {:piano, 1}

  def read_notes(bar, 13) when rem(bar, 2) > 0 do
    [
      {60, 100, :mp},
      {63, 100, :mp},
      {65, 100, :mp},
      {67, 100, :mp}
    ]
  end
end
