defmodule MagicFlute do
  alias MagicFlute.{Conductor, DemoEnsemble}

  def demo() do
    players = [
      DemoEnsemble.PianoPlayer,
      DemoEnsemble.BassPlayer,
      DemoEnsemble.KickPlayer,
      DemoEnsemble.SnarePlayer,
      DemoEnsemble.HiHatPlayer
    ]

    bpm = 120
    signature = {4, 4}

    Conductor.start_performance(players, bpm, signature, 16)
  end

  def metronome() do
    players = [
      DemoEnsemble.MetronomePlayer
    ]

    bpm = 120
    signature = {4, 4}

    Conductor.start_performance(players, bpm, signature, 4)
  end
end
