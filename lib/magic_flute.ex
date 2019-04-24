defmodule MagicFlute do
  alias MagicFlute.{Conductor, DemoEnsemble}

  def demo() do
    ensemble = [
      DemoEnsemble.PianoPlayer,
      DemoEnsemble.BassPlayer,
      DemoEnsemble.KickPlayer,
      DemoEnsemble.SnarePlayer,
      DemoEnsemble.HiHatPlayer
    ]

    bpm = 120
    signature = {4, 4}

    Conductor.start_performance(ensemble, bpm, signature, 16)
  end

  def metronome() do
    ensemble = [
      DemoEnsemble.MetronomePlayer
    ]

    bpm = 120
    signature = {4, 4}

    Conductor.start_performance(ensemble, bpm, signature, 4)
  end

  def play_scale() do
    MagicFlute.Note.scale(:minor_melodic, "a", 2..2)
    |> Enum.map(fn tone ->
      MagicFlute.Instrument.play({tone, 10, 100}, {:piano, 1})
      :timer.sleep(250)
    end)

    :noop
  end
end
