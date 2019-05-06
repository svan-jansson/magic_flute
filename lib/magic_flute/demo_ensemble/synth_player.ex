defmodule MagicFlute.DemoEnsemble.SynthPlayer do
  @moduledoc false

  use MagicFlute.Player,
    instrument: {
      :synth_lead,
      1
    },
    note_sheet: [
      {1..8, __MODULE__, :intro},
      {9..13, __MODULE__, :bridge}
    ]

  def bridge(bar, beat) do
    IO.inspect(:bridge)
    []
  end

  def intro(bar, beat) do
    IO.inspect(:intro)

    # chord(:c, :minor_harmonic, :tonic, 2..5)
    # |> arpeggiator(bar, beat)
    []
  end
end
