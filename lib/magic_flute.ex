defmodule MagicFlute do
  alias MagicFlute.{Conductor, Ensemble, Performance}

  def start_performence(bpm, signature \\ {4, 4}) do
    Conductor.add_player(Ensemble.PianoPlayer)
    Conductor.add_player(Ensemble.BassPlayer)
    Conductor.add_player(Ensemble.KickPlayer)
    Conductor.add_player(Ensemble.SnarePlayer)
    Conductor.add_player(Ensemble.HiHatPlayer)

    Performance.start(bpm, signature)
  end
end
