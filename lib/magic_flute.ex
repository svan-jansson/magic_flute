defmodule MagicFlute do
  @moduledoc """

  """

  def test() do
    ensemble = [MagicFlute.DemoEnsemble.SynthPlayer]
    bpm = 120
    signature = {4, 4}
    length_in_bars = 20
    MagicFlute.Conductor.start_performance(ensemble, bpm, signature, length_in_bars)
  end
end
